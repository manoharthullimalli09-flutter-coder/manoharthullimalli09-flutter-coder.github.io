part of 'hero_bloc.dart';

abstract class HeroEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadDeveloperInfo extends HeroEvent {}
