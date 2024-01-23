import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:streaming_data_dashboard/models/plant_model.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<SettingsButtonOnClickedEvent>(settingsButtonOnClickedEvent);
    on<OnPlantClickedEvent>(onPlantClickedEvent);
  }

  FutureOr<void> settingsButtonOnClickedEvent(
      SettingsButtonOnClickedEvent event, Emitter<HomeState> emit) {
    emit(NavigateToSettingsPageActionState());
  }

  FutureOr<void> onPlantClickedEvent(
      OnPlantClickedEvent event, Emitter<HomeState> emit) {
    emit(NavigateToDashboardPageActionState(plant: event.plant));
  }
}
