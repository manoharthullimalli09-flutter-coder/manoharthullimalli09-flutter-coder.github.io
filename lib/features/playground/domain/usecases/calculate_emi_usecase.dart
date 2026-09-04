import 'dart:math' as math;

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/calculator_results.dart';

class EmiParams extends Equatable {
  final double principal;
  final double annualRatePercent;
  final int months;

  const EmiParams({
    required this.principal,
    required this.annualRatePercent,
    required this.months,
  });

  @override
  List<Object> get props => [principal, annualRatePercent, months];
}

class CalculateEmiUseCase implements SyncUseCase<EmiResultEntity, EmiParams> {
  const CalculateEmiUseCase();

  @override
  Either<Failure, EmiResultEntity> call(EmiParams params) {
    if (params.principal <= 0) {
      return const Left(ValidationFailure('Loan amount must be above zero.'));
    }
    if (params.months <= 0) {
      return const Left(ValidationFailure('Tenure must be at least 1 month.'));
    }
    if (params.annualRatePercent < 0) {
      return const Left(ValidationFailure('Interest rate cannot be negative.'));
    }

    final n = params.months;
    final p = params.principal;
    final r = params.annualRatePercent / 12 / 100;

    // A 0% loan divides by zero in the standard formula — it is just the
    // principal split evenly across the tenure.
    final emi = r == 0
        ? p / n
        : p * r * math.pow(1 + r, n) / (math.pow(1 + r, n) - 1);

    final totalPayable = emi * n;

    return Right(
      EmiResultEntity(
        principal: p,
        monthlyEmi: emi,
        totalInterest: totalPayable - p,
        totalPayable: totalPayable,
      ),
    );
  }
}
