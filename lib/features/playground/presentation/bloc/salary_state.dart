part of 'salary_cubit.dart';

class SalaryState extends Equatable {
  final double ctc;
  final double basicPercent;
  final bool isMetro;
  final SalaryBreakdownEntity? result;
  final String? error;

  const SalaryState({
    this.ctc = 1200000,
    this.basicPercent = 0.40,
    this.isMetro = true,
    this.result,
    this.error,
  });

  SalaryState copyWith({
    double? ctc,
    double? basicPercent,
    bool? isMetro,
    SalaryBreakdownEntity? result,
    String? error,
    bool clearResult = false,
    bool clearError = false,
  }) => SalaryState(
    ctc: ctc ?? this.ctc,
    basicPercent: basicPercent ?? this.basicPercent,
    isMetro: isMetro ?? this.isMetro,
    result: clearResult ? null : (result ?? this.result),
    error: clearError ? null : (error ?? this.error),
  );

  @override
  List<Object?> get props => [ctc, basicPercent, isMetro, result, error];
}
