import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:streaming_data_dashboard/core/exceptions/api_exceptions.dart';
import 'package:streaming_data_dashboard/features/settings/repository/setting_repository.dart';
import 'package:streaming_data_dashboard/models/plant_model.dart';
import 'package:streaming_data_dashboard/models/user_model.dart';
import 'package:streaming_data_dashboard/service_locator.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final SettingRepository _settingRepository = sl.get<SettingRepository>();

  SettingsBloc() : super(SettingsInitial()) {
    on<SettingsEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<TabChangeEvent>(onTabChangeEvent);
    on<OnPlantClickedEvent>(onPlantClickedEvent);
    on<PlantDataFetchEvent>(onPlantDataFetchEvent);
    on<UserDataFetchEvent>(onUserDataFetchEvent);
    on<ButtonAddUserClickedEvent>(onButtonAddUserClickedEvent);
    on<ButtonEditUserClickedEvent>(onButtonEditUserClickedEvent);
    on<ButtonAddPlantClickedEvent>(onButtonAddPlantClickedEvent);
    on<AddUserEvent>(onAddUserEvent);
    on<DeleteUserEvent>(onDeleteUserEvent);
    on<EditUserEvent>(onEditUserEvent);
    on<AddPlantEvent>(onAddPlantEvent);
    on<ButtonDeletePlantClickedEvent>(onButtonDeletePlantClickedEvent);
  }

  FutureOr<void> onTabChangeEvent(
      TabChangeEvent event, Emitter<SettingsState> emit) {
    emit(TabChangeState(index: event.index));
  }

  FutureOr<void> onPlantClickedEvent(
      OnPlantClickedEvent event, Emitter<SettingsState> emit) {
    emit(NavigateToUnitEditPageActionState(plant: event.plant));
  }

  Future<FutureOr<void>> onPlantDataFetchEvent(
      PlantDataFetchEvent event, Emitter<SettingsState> emit) async {
    emit(PlantLoadingState());
    try {
      final data = await _settingRepository.getAllPlants();
      emit(PlantLoadingSuccessState(plants: data));
    } on ApiException catch (e) {
      emit(PlantLoadingFailedState(apiException: e));
    }
  }

  FutureOr<void> onUserDataFetchEvent(
      UserDataFetchEvent event, Emitter<SettingsState> emit) async {
    emit(UsersLoadingState());
    try {
      final data = await _settingRepository.getAllUsers();
      emit(UsersLoadingSuccessState(users: data));
    } on ApiException catch (e) {
      emit(UsersLoadingFailedState(apiException: e));
    }
  }

  FutureOr<void> onButtonAddUserClickedEvent(
      ButtonAddUserClickedEvent event, Emitter<SettingsState> emit) {
    emit(OpenAddUserDialogState());
  }

  FutureOr<void> onAddUserEvent(
      AddUserEvent event, Emitter<SettingsState> emit) async {
    emit(UsersLoadingState());
    try {
      final data = await _settingRepository.addUser(
          event.employeeId,
          event.firstName,
          event.lastName,
          event.username,
          event.email,
          event.contactNo,
          event.password,
          event.isAdmin);
    } on ApiException catch (e) {
      emit(UsersLoadingFailedState(apiException: e));
    }
  }

  FutureOr<void> onDeleteUserEvent(
      DeleteUserEvent event, Emitter<SettingsState> emit) async {
    try {
      await _settingRepository.deleteUser(event.user.id);
      emit(DeleteUserSuccessState());
    } on ApiException catch (e) {
      emit(UsersLoadingFailedState(apiException: e));
    }
  }

  FutureOr<void> onEditUserEvent(
      EditUserEvent event, Emitter<SettingsState> emit) async {
    try {
      final data = await _settingRepository.editUser(event.user);
      emit(EditUserSuccessState(user: data));
    } on ApiException catch (e) {
      emit(UsersLoadingFailedState(apiException: e));
    }
  }

  FutureOr<void> onButtonEditUserClickedEvent(
      ButtonEditUserClickedEvent event, Emitter<SettingsState> emit) {
    emit(OpenEditUserDialogState(user: event.user));
  }

  FutureOr<void> onButtonAddPlantClickedEvent(
      ButtonAddPlantClickedEvent event, Emitter<SettingsState> emit) {
    emit(OpenAddPlantDialogState());
  }

  Future<FutureOr<void>> onAddPlantEvent(
      AddPlantEvent event, Emitter<SettingsState> emit) async {
    emit(PlantLoadingState());
    try {
      final data = await _settingRepository.addPlant(event.name);
      emit(AddPlantSuccessState(plant: data));
    } on ApiException catch (e) {
      emit(PlantLoadingFailedState(apiException: e));
    }
  }

  Future<FutureOr<void>> onButtonDeletePlantClickedEvent(
      ButtonDeletePlantClickedEvent event, Emitter<SettingsState> emit) async {
    try {
      await _settingRepository.deletePlant(event.plant.id);
      emit(OnDeletePlantSuccessState());
    } on ApiException catch (e) {
      emit(UsersLoadingFailedState(apiException: e));
    }
  }
}
