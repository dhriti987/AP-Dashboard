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

class UserDataFetchEvent extends SettingsEvent {}

class ButtonAddUserClickedEvent extends SettingsEvent {}

class AddPlantEvent extends SettingsEvent {
  final String name;

  AddPlantEvent({required this.name});
}

class AddUserEvent extends SettingsEvent {
  final String employeeId;
  final String firstName;
  final String lastName;
  final String username;
  final String email;
  final String password;
  final String contactNo;
  final bool isAdmin;

  AddUserEvent(
      {required this.employeeId,
      required this.firstName,
      required this.lastName,
      required this.username,
      required this.email,
      required this.password,
      required this.contactNo,
      required this.isAdmin});
}

class DeleteUserEvent extends SettingsEvent {
  final UserModel user;

  DeleteUserEvent({required this.user});
}

class EditUserEvent extends SettingsEvent {
  final UserModel user;

  EditUserEvent({required this.user});
}

class ButtonEditUserClickedEvent extends SettingsEvent {
  final UserModel user;

  ButtonEditUserClickedEvent({required this.user});
}

class ButtonAddPlantClickedEvent extends SettingsEvent {
  ButtonAddPlantClickedEvent();
}

class ButtonDeletePlantClickedEvent extends SettingsEvent {
  final Plant plant;

  ButtonDeletePlantClickedEvent({required this.plant});
}
