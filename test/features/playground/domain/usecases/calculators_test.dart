import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_portfolio/core/errors/failures.dart';
import 'package:flutter_portfolio/features/playground/domain/entities/calculator_results.dart';
import 'package:flutter_portfolio/features/playground/domain/usecases/calculate_emi_usecase.dart';
import 'package:flutter_portfolio/features/playground/domain/usecases/calculate_salary_usecase.dart';
import 'package:flutter_portfolio/features/playground/domain/usecases/calculate_sip_usecase.dart';

/// Unwraps a Right, failing the test if the use case returned a Failure.
T unwrap<T>(dynamic either) => either.fold(
      (f) => fail('expected a result, got failure: ${(f as Failure).message}'),
      (r) => r as T,
    );

void main() {
  group('CalculateEmiUseCase', () {
    const usecase = CalculateEmiUseCase();

    test('matches the standard amortisation formula', () {
      // ₹10L at 9% over 20 years is a textbook case: EMI ≈ ₹8,997.
      final r = unwrap<EmiResultEntity>(usecase(const EmiParams(
        principal: 1000000,
        annualRatePercent: 9,
        months: 240,
      )));

      expect(r.monthlyEmi, closeTo(8997.26, 1));
      expect(r.totalPayable, closeTo(r.monthlyEmi * 240, 0.01));
      expect(r.totalInterest, closeTo(r.totalPayable - 1000000, 0.01));
    });

    test('a 0% loan is the principal split evenly, not a divide-by-zero', () {
      final r = unwrap<EmiResultEntity>(usecase(const EmiParams(
        principal: 120000,
        annualRatePercent: 0,
        months: 12,
      )));

      expect(r.monthlyEmi, closeTo(10000, 0.01));
      expect(r.totalInterest, closeTo(0, 0.01));
    });

    test('interestShare stays within 0..1', () {
      final r = unwrap<EmiResultEntity>(usecase(const EmiParams(
        principal: 500000,
        annualRatePercent: 12,
        months: 60,
      )));
      expect(r.interestShare, inInclusiveRange(0, 1));
    });

    test('rejects a zero principal, a zero tenure and a negative rate', () {
      for (final p in const [
        EmiParams(principal: 0, annualRatePercent: 9, months: 12),
        EmiParams(principal: 1000, annualRatePercent: 9, months: 0),
        EmiParams(principal: 1000, annualRatePercent: -1, months: 12),
      ]) {
        expect(usecase(p).isLeft(), isTrue, reason: '$p should be rejected');
      }
    });
  });

  group('CalculateSipUseCase', () {
    const usecase = CalculateSipUseCase();

    test('₹5,000/mo at 12% for 10 years ≈ ₹11.6L', () {
      final r = unwrap<SipResultEntity>(usecase(const SipParams(
        monthlyInvestment: 5000,
        annualReturnPercent: 12,
        years: 10,
      )));

      expect(r.investedAmount, closeTo(600000, 0.01));
      expect(r.totalValue, closeTo(1161695, 2000));
      expect(r.estimatedReturns, closeTo(r.totalValue - 600000, 0.01));
    });

    test('a 0% return returns exactly what was paid in', () {
      final r = unwrap<SipResultEntity>(usecase(const SipParams(
        monthlyInvestment: 1000,
        annualReturnPercent: 0,
        years: 5,
      )));

      expect(r.totalValue, closeTo(60000, 0.01));
      expect(r.estimatedReturns, closeTo(0, 0.01));
    });

    test('rejects zero investment and zero duration', () {
      expect(
        usecase(const SipParams(
          monthlyInvestment: 0,
          annualReturnPercent: 12,
          years: 5,
        )).isLeft(),
        isTrue,
      );
      expect(
        usecase(const SipParams(
          monthlyInvestment: 5000,
          annualReturnPercent: 12,
          years: 0,
        )).isLeft(),
        isTrue,
      );
    });
  });

  group('CalculateSalaryUseCase', () {
    const usecase = CalculateSalaryUseCase();

    test('CTC splits into components that add back up to the CTC', () {
      final r = unwrap<SalaryBreakdownEntity>(
        usecase(const SalaryParams(ctc: 1200000)),
      );

      final sum = r.basic + r.hra + r.otherAllowances + r.employerPf + r.gratuity;
      expect(sum, closeTo(r.ctc, 0.01));
    });

    test('12 LPA pays no income tax under the new regime rebate', () {
      final r = unwrap<SalaryBreakdownEntity>(
        usecase(const SalaryParams(ctc: 1200000)),
      );

      expect(r.incomeTax, 0);
      expect(r.monthlyInHand, closeTo(88276, 500));
    });

    test('25 LPA is taxed on the slabs above the rebate limit', () {
      final r = unwrap<SalaryBreakdownEntity>(
        usecase(const SalaryParams(ctc: 2500000)),
      );

      expect(r.incomeTax, greaterThan(0));
      expect(r.incomeTax, closeTo(274794, 2000));
      expect(r.annualInHand, lessThan(r.ctc));
    });

    test('marginal relief keeps tax from exceeding income above the limit', () {
      // Just past the ₹12L rebate cliff, tax must not exceed the excess —
      // otherwise a ₹1 raise would cost tens of thousands.
      final r = unwrap<SalaryBreakdownEntity>(
        usecase(const SalaryParams(ctc: 1400000)),
      );

      final taxable = (r.ctc - r.employerPf - r.gratuity) -
          CalculateSalaryUseCase.standardDeduction;
      final excess = taxable - CalculateSalaryUseCase.rebateLimit;
      expect(r.incomeTax, lessThanOrEqualTo(excess * (1 + 0.04) + 1));
    });

    test('non-metro HRA is lower than metro for the same CTC', () {
      final metro = unwrap<SalaryBreakdownEntity>(
        usecase(const SalaryParams(ctc: 1500000)),
      );
      final nonMetro = unwrap<SalaryBreakdownEntity>(
        usecase(const SalaryParams(ctc: 1500000, isMetro: false)),
      );

      expect(nonMetro.hra, lessThan(metro.hra));
    });

    test('rejects a zero CTC and an out-of-range basic percentage', () {
      expect(usecase(const SalaryParams(ctc: 0)).isLeft(), isTrue);
      expect(
        usecase(const SalaryParams(ctc: 100000, basicPercent: 1.5)).isLeft(),
        isTrue,
      );
    });
  });
}
