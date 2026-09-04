import 'dart:math' as math;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/calculator_results.dart';

class SipParams extends Equatable {
  final double monthlyInvestment;
  final double annualReturnPercent;
  final int years;

  const SipParams({
    required this.monthlyInvestment,
    required this.annualReturnPercent,
    required this.years,
  });

  @override
  List<Object> get props => [monthlyInvestment, annualReturnPercent, years];
}

class CalculateSipUseCase implements SyncUseCase<SipResultEntity, SipParams> {
  const CalculateSipUseCase();

  @override
  Either<Failure, SipResultEntity> call(SipParams params) {
    if (params.monthlyInvestment <= 0) {
      return const Left(
        ValidationFailure('Monthly investment must be above zero.'),
      );
    }
    if (params.years <= 0) {
      return const Left(ValidationFailure('Duration must be at least 1 year.'));
    }
    if (params.annualReturnPercent < 0) {
      return const Left(
        ValidationFailure('Expected return cannot be negative.'),
      );
    }

    final n = params.years * 12;
    final p = params.monthlyInvestment;
    final i = params.annualReturnPercent / 12 / 100;

    // Future value of an annuity-due: each instalment compounds from the
    // month it is paid, so the series is multiplied by (1 + i).
    final futureValue =
        i == 0 ? p * n : p * ((math.pow(1 + i, n) - 1) / i) * (1 + i);

    final invested = p * n;

    return Right(
      SipResultEntity(
        investedAmount: invested,
        estimatedReturns: futureValue - invested,
        totalValue: futureValue,
      ),
    );
  }
}
