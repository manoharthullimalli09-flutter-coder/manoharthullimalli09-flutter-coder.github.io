import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/calculator_results.dart';
import '../../domain/usecases/calculate_emi_usecase.dart';

part 'emi_state.dart';

class EmiCubit extends Cubit<EmiState> {
  final CalculateEmiUseCase calculateEmi;

  EmiCubit({required this.calculateEmi}) : super(const EmiState()) {
    _recalculate();
  }

  void setPrincipal(double v) => _update(state.copyWith(principal: v));
  void setRate(double v) => _update(state.copyWith(rate: v));
  void setMonths(int v) => _update(state.copyWith(months: v));

  void _update(EmiState next) {
    emit(next);
    _recalculate();
  }

  void _recalculate() {
    final result = calculateEmi(
      EmiParams(
        principal: state.principal,
        annualRatePercent: state.rate,
        months: state.months,
      ),
    );
    result.fold(
      (failure) => emit(state.copyWith(error: failure.message, clearResult: true)),
      (r) => emit(state.copyWith(result: r, clearError: true)),
    );
  }
}
