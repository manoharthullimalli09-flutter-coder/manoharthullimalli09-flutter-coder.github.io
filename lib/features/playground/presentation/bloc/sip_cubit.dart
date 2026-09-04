import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/calculator_results.dart';
import '../../domain/usecases/calculate_sip_usecase.dart';

part 'sip_state.dart';

class SipCubit extends Cubit<SipState> {
  final CalculateSipUseCase calculateSip;

  SipCubit({required this.calculateSip}) : super(const SipState()) {
    _recalculate();
  }

  void setMonthly(double v) => _update(state.copyWith(monthly: v));
  void setReturnRate(double v) => _update(state.copyWith(returnRate: v));
  void setYears(int v) => _update(state.copyWith(years: v));

  void _update(SipState next) {
    emit(next);
    _recalculate();
  }

  void _recalculate() {
    final result = calculateSip(
      SipParams(
        monthlyInvestment: state.monthly,
        annualReturnPercent: state.returnRate,
        years: state.years,
      ),
    );
    result.fold(
      (failure) => emit(state.copyWith(error: failure.message, clearResult: true)),
      (r) => emit(state.copyWith(result: r, clearError: true)),
    );
  }
}
