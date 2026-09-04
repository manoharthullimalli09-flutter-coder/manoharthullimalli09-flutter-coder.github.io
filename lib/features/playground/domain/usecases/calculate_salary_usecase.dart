import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/calculator_results.dart';

class SalaryParams extends Equatable {
  final double ctc;

  /// Basic pay as a share of CTC. Offer letters vary; 40% is the common
  /// default and the figure most Indian CTC breakups assume.
  final double basicPercent;

  /// Metro cities attract HRA at 50% of basic instead of 40%.
  final bool isMetro;

  const SalaryParams({
    required this.ctc,
    this.basicPercent = 0.40,
    this.isMetro = true,
  });

  @override
  List<Object> get props => [ctc, basicPercent, isMetro];
}

/// India, **New Tax Regime (FY 2025-26)**. Figures are an estimate: real
/// take-home depends on the employer's exact CTC structure, the state's
/// professional tax, and any declared investments.
class CalculateSalaryUseCase
    implements SyncUseCase<SalaryBreakdownEntity, SalaryParams> {
  const CalculateSalaryUseCase();

  static const standardDeduction = 75000.0;
  static const rebateLimit = 1200000.0;
  static const cessRate = 0.04;
  static const professionalTaxAnnual = 2400.0;

  /// Upper bound of each slab paired with the rate applied within it.
  static const _slabs = <(double, double)>[
    (400000, 0.00),
    (800000, 0.05),
    (1200000, 0.10),
    (1600000, 0.15),
    (2000000, 0.20),
    (2400000, 0.25),
    (double.infinity, 0.30),
  ];

  @override
  Either<Failure, SalaryBreakdownEntity> call(SalaryParams params) {
    if (params.ctc <= 0) {
      return const Left(ValidationFailure('CTC must be above zero.'));
    }
    if (params.basicPercent <= 0 || params.basicPercent > 1) {
      return const Left(
        ValidationFailure('Basic must be between 1% and 100% of CTC.'),
      );
    }

    final ctc = params.ctc;
    final basic = ctc * params.basicPercent;
    final hra = basic * (params.isMetro ? 0.50 : 0.40);

    // Both are employer costs counted inside CTC but never paid out monthly,
    // so they leave the gross before tax is computed.
    final employerPf = basic * 0.12;
    final gratuity = basic * 0.0481;

    final otherAllowances = ctc - basic - hra - employerPf - gratuity;
    final grossSalary = ctc - employerPf - gratuity;

    final employeePf = basic * 0.12;
    final incomeTax = _incomeTax(grossSalary);

    final annualInHand =
        grossSalary - employeePf - professionalTaxAnnual - incomeTax;

    return Right(
      SalaryBreakdownEntity(
        ctc: ctc,
        basic: basic,
        hra: hra,
        otherAllowances: otherAllowances,
        employeePf: employeePf,
        employerPf: employerPf,
        gratuity: gratuity,
        professionalTax: professionalTaxAnnual,
        incomeTax: incomeTax,
        annualInHand: annualInHand,
      ),
    );
  }

  double _incomeTax(double grossSalary) {
    final taxable = grossSalary - standardDeduction;
    if (taxable <= 0) return 0;

    var tax = 0.0;
    var lower = 0.0;
    for (final (upper, rate) in _slabs) {
      if (taxable <= lower) break;
      final slice = (taxable < upper ? taxable : upper) - lower;
      tax += slice * rate;
      lower = upper;
    }

    // Section 87A wipes the liability out entirely up to the rebate limit.
    if (taxable <= rebateLimit) return 0;

    // Marginal relief: just above the limit, tax can never exceed the amount
    // by which income crosses it — otherwise earning ₹1 more costs far more.
    final excess = taxable - rebateLimit;
    if (tax > excess) tax = excess;

    return tax * (1 + cessRate);
  }
}
