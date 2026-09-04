part of 'sip_cubit.dart';

class SipState extends Equatable {
  final double monthly;
  final double returnRate;
  final int years;
  final SipResultEntity? result;
  final String? error;

  const SipState({
    this.monthly = 10000,
    this.returnRate = 12,
    this.years = 10,
    this.result,
    this.error,
  });

  SipState copyWith({
    double? monthly,
    double? returnRate,
    int? years,
    SipResultEntity? result,
    String? error,
    bool clearResult = false,
    bool clearError = false,
  }) => SipState(
    monthly: monthly ?? this.monthly,
    returnRate: returnRate ?? this.returnRate,
    years: years ?? this.years,
    result: clearResult ? null : (result ?? this.result),
    error: clearError ? null : (error ?? this.error),
  );

  @override
  List<Object?> get props => [monthly, returnRate, years, result, error];
}
