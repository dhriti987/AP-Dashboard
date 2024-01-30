import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:streaming_data_dashboard/core/exceptions/api_exceptions.dart';
import 'package:streaming_data_dashboard/features/settings/repository/setting_repository.dart';
import 'package:streaming_data_dashboard/models/plant_model.dart';
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
}
