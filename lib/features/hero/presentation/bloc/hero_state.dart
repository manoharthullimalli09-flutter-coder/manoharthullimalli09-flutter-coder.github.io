part of 'hero_bloc.dart';

abstract class HeroState extends Equatable {
  @override
  List<Object?> get props => [];
}

class HeroInitial extends HeroState {}

class HeroLoading extends HeroState {}

class HeroLoaded extends HeroState {
  final DeveloperEntity developer;
  HeroLoaded(this.developer);

  @override
  List<Object> get props => [developer];
}

class HeroError extends HeroState {
  final String message;
  HeroError(this.message);

  @override
  List<Object> get props => [message];
}
