part of 'contact_bloc.dart';

abstract class ContactEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitContactForm extends ContactEvent {
  final ContactFormEntity form;
  SubmitContactForm(this.form);

  @override
  List<Object> get props => [form];
}

class ResetContactForm extends ContactEvent {}
