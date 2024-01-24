import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:streaming_data_dashboard/core/exceptions/api_exceptions.dart';
import 'package:streaming_data_dashboard/features/dashboard/repository/dashboard_repository.dart';
import 'package:streaming_data_dashboard/models/unit_model.dart';
import 'package:streaming_data_dashboard/service_locator.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardRepository _dashboardRepository = sl.get<DashboardRepository>();
  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardEvent>((event, emit) {});
    on<FetchUnitDataEvent>(onFetchUnitDataEvent);
  }

  FutureOr<void> onFetchUnitDataEvent(
      FetchUnitDataEvent event, Emitter<DashboardState> emit) async {
    emit(DashboardLoadingState());
    try {
      var data = await _dashboardRepository.getAllUnitsByPlant(event.plantName);
      double totalValue = 0;
      double maxValue = 0;
      data.forEach(
        (element) {
          totalValue += element.unitValue;
          maxValue += element.maxVoltage;
        },
      );
      emit(DashboardLoadingSuccessState(
          units: data,
          frequency: 50.1,
          totalValue: totalValue,
          maxValue: maxValue));
    } on ApiException catch (e) {
      emit(DashboardLoadingFailedState(apiException: e));
    }
  }
}
