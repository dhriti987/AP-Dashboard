import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:streaming_data_dashboard/models/plant_model.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(SettingsInitial()) {
    on<SettingsEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<TabChangeEvent>(onTabChangeEvent);
    on<OnPlantClickedEvent>(onPlantClickedEvent);
  }

  FutureOr<void> onTabChangeEvent(
      TabChangeEvent event, Emitter<SettingsState> emit) {
    emit(TabChangeState(index: event.index));
  }

  FutureOr<void> onPlantClickedEvent(
      OnPlantClickedEvent event, Emitter<SettingsState> emit) {
    emit(NavigateToUnitEditPageActionState(plant: event.plant));
  }
}
