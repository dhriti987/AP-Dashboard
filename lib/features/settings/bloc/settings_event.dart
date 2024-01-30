part of 'settings_bloc.dart';

@immutable
sealed class SettingsEvent {}

class TabChangeEvent extends SettingsEvent {
  final int index;

  TabChangeEvent({required this.index});
}

class OnPlantClickedEvent extends SettingsEvent {
  final Plant plant;

  OnPlantClickedEvent({required this.plant});
}

class PlantDataFetchEvent extends SettingsEvent {}
