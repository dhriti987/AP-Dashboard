part of 'settings_bloc.dart';

@immutable
sealed class SettingsState {}

sealed class SettingsActionState extends SettingsState {}

final class SettingsInitial extends SettingsState {}

class TabChangeState extends SettingsState {
  final int index;

  TabChangeState({required this.index});
}

class NavigateToUnitEditPageActionState extends SettingsActionState {
  final Plant plant;

  NavigateToUnitEditPageActionState({required this.plant});
}

class PlantInitialState extends SettingsState {}

class PlantLoadingState extends SettingsState {}

class PlantLoadingFailedState extends SettingsState {
  final ApiException apiException;

  PlantLoadingFailedState({required this.apiException});
}

class PlantLoadingSuccessState extends SettingsState {
  final List<Plant> plants;

  PlantLoadingSuccessState({required this.plants});
}
