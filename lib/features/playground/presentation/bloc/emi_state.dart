part of 'emi_cubit.dart';

class EmiState extends Equatable {
  final double principal;
  final double rate;
  final int months;
  final EmiResultEntity? result;
  final String? error;

  const EmiState({
    this.principal = 2500000,
    this.rate = 8.5,
    this.months = 240,
    this.result,
    this.error,
  });

  int get years => months ~/ 12;

  EmiState copyWith({
    double? principal,
    double? rate,
    int? months,
    EmiResultEntity? result,
    String? error,
    bool clearResult = false,
    bool clearError = false,
  }) => EmiState(
    principal: principal ?? this.principal,
    rate: rate ?? this.rate,
    months: months ?? this.months,
    result: clearResult ? null : (result ?? this.result),
    error: clearError ? null : (error ?? this.error),
  );

  @override
  List<Object?> get props => [principal, rate, months, result, error];
}
