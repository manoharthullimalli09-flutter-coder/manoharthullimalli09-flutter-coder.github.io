import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/contact_form_entity.dart';
import '../../domain/usecases/submit_contact_form_usecase.dart';

part 'contact_event.dart';
part 'contact_state.dart';

class ContactBloc extends Bloc<ContactEvent, ContactState> {
  final SubmitContactFormUseCase submitForm;

  ContactBloc({required this.submitForm}) : super(ContactInitial()) {
    on<SubmitContactForm>(_onSubmit);
    on<ResetContactForm>(_onReset);
  }

  Future<void> _onSubmit(
    SubmitContactForm event,
    Emitter<ContactState> emit,
  ) async {
    emit(ContactSubmitting());
    final result = await submitForm(event.form);
    result.fold(
      (failure) => emit(ContactError(failure.message)),
      (_) => emit(ContactSuccess()),
    );
  }

  void _onReset(ResetContactForm event, Emitter<ContactState> emit) {
    emit(ContactInitial());
  }
}
