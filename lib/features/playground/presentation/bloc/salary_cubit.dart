import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/calculator_results.dart';
import '../../domain/usecases/calculate_salary_usecase.dart';

part 'salary_state.dart';

class SalaryCubit extends Cubit<SalaryState> {
  final CalculateSalaryUseCase calculateSalary;

  SalaryCubit({required this.calculateSalary}) : super(const SalaryState()) {
    _recalculate();
  }

  void setCtc(double v) => _update(state.copyWith(ctc: v));
  void setBasicPercent(double v) => _update(state.copyWith(basicPercent: v));
  void setMetro(bool v) => _update(state.copyWith(isMetro: v));

  void _update(SalaryState next) {
    emit(next);
    _recalculate();
  }

  void _recalculate() {
    final result = calculateSalary(
      SalaryParams(
        ctc: state.ctc,
        basicPercent: state.basicPercent,
        isMetro: state.isMetro,
      ),
    );
    result.fold(
      (failure) => emit(state.copyWith(error: failure.message, clearResult: true)),
      (r) => emit(state.copyWith(result: r, clearError: true)),
    );
  }
}
