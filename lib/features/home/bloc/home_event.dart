part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class HomeDataFetchEvent extends HomeEvent {}

class SettingsButtonOnClickedEvent extends HomeEvent {}

class OnPlantClickedEvent extends HomeEvent {
  final Plant plant;

  OnPlantClickedEvent({required this.plant});
}
