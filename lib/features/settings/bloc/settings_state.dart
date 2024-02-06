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

// -------------------------------------------------------
// Plants
// -------------------------------------------------------

class PlantLoadingState extends SettingsState {}

class PlantLoadingFailedState extends SettingsState {
  final ApiException apiException;

  PlantLoadingFailedState({required this.apiException});
}

class PlantLoadingSuccessState extends SettingsState {
  final List<Plant> plants;

  PlantLoadingSuccessState({required this.plants});
}

class OpenAddPlantDialogState extends SettingsActionState {}

class OnDeletePlantSuccessState extends SettingsState {}

class AddPlantSuccessState extends SettingsState {
  final Plant plant;

  AddPlantSuccessState({required this.plant});

  @override
  bool operator ==(Object other) {
    return false;
  }

  @override
  // TODO: implement hashCode
  int get hashCode => super.hashCode;
}

// -------------------------------------------------------
// Users
// -------------------------------------------------------
class UsersLoadingState extends SettingsState {}

class UsersLoadingFailedState extends SettingsState {
  final ApiException apiException;

  UsersLoadingFailedState({required this.apiException});
}

class UsersLoadingSuccessState extends SettingsState {
  final List<UserModel> users;

  UsersLoadingSuccessState({required this.users});
}

class OpenAddUserDialogState extends SettingsActionState {}

class OpenEditUserDialogState extends SettingsActionState {
  final UserModel user;

  OpenEditUserDialogState({required this.user});
}

class AddUserSuccessState extends SettingsState {
  final UserModel user;

  AddUserSuccessState({required this.user});
}

class DeleteUserSuccessState extends SettingsState {}

class EditUserSuccessState extends SettingsState {
  final UserModel user;

  EditUserSuccessState({required this.user});
}

class LogoutSuccessState extends SettingsActionState {}
