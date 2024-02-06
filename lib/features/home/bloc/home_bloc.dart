import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:streaming_data_dashboard/core/exceptions/api_exceptions.dart';
import 'package:streaming_data_dashboard/features/home/repository/home_repository.dart';
import 'package:streaming_data_dashboard/features/login/repository/login_repository.dart';
import 'package:streaming_data_dashboard/models/plant_model.dart';
import 'package:streaming_data_dashboard/service_locator.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _homeRepository = sl.get<HomeRepository>();

  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<HomeDataFetchEvent>(onHomeDataFetchEvent);
    on<SettingsButtonOnClickedEvent>(settingsButtonOnClickedEvent);
    on<OnPlantClickedEvent>(onPlantClickedEvent);
    on<LogoutButtonClickedEvent>(onLogoutButtonClickedEvent);
  }

  FutureOr<void> settingsButtonOnClickedEvent(
      SettingsButtonOnClickedEvent event, Emitter<HomeState> emit) {
    emit(NavigateToSettingsPageActionState());
  }

  FutureOr<void> onPlantClickedEvent(
      OnPlantClickedEvent event, Emitter<HomeState> emit) {
    emit(NavigateToDashboardPageActionState(plant: event.plant));
  }

  FutureOr<void> onHomeDataFetchEvent(
      HomeDataFetchEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());
    try {
      final data = await _homeRepository.getAllPlants();
      emit(HomeLoadingSuccessState(plants: data));
    } on ApiException catch (e) {
      emit(HomeLoadingFailedState(apiException: e));
    }
  }

  Future<FutureOr<void>> onLogoutButtonClickedEvent(
      LogoutButtonClickedEvent event, Emitter<HomeState> emit) async {
    await sl.get<LoginRepository>().logout();
    emit(LogoutSuccessState());
  }
}
