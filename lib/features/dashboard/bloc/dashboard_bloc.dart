import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:streaming_data_dashboard/core/exceptions/api_exceptions.dart';
import 'package:streaming_data_dashboard/features/dashboard/repository/dashboard_repository.dart';
import 'package:streaming_data_dashboard/features/dashboard/repository/unit_analysis_repository.dart';
import 'package:streaming_data_dashboard/models/unit_model.dart';
import 'package:streaming_data_dashboard/service_locator.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardRepository _dashboardRepository = sl.get<DashboardRepository>();
  UnitAnalysisRepository _unitAnalysisRepository =
      sl.get<UnitAnalysisRepository>();
  DashboardBloc() : super(DashboardInitial()) {
    on<DashboardEvent>((event, emit) {});
    on<FetchUnitDataEvent>(onFetchUnitDataEvent);
    on<UnitValueChangedEvent>(onUnitValueChangedEvent);
    on<FetchDatapointsEvent>(onFetchDatapointsEvent);
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

  FutureOr<void> onUnitValueChangedEvent(
      UnitValueChangedEvent event, Emitter<DashboardState> emit) {
    try {
      List<dynamic> pointData = json.decode(event.data);
      double totalValue = 0;
      double maxValue = 0;
      for (var element in event.units) {
        final index =
            pointData.indexWhere((e) => e["pointId"] == element.pointId);
        element.unitValue = pointData[index]["pointValues"];
        totalValue += element.unitValue;
        maxValue += element.maxVoltage;
      }
      emit(DashboardLoadingSuccessState(
          units: event.units,
          frequency: 50.1,
          totalValue: totalValue,
          maxValue: maxValue));
    } catch (e) {
      print(e);
    }
  }

  FutureOr<void> onFetchDatapointsEvent(
      FetchDatapointsEvent event, Emitter<DashboardState> emit) async {
    emit(UnitAnalysisLodingState());
    try {
      List<dynamic> data =
          await _unitAnalysisRepository.getUnit24hrData(event.unitId);
      double total = 0;
      double min_power = double.infinity;
      double max_power = double.negativeInfinity;
      List<Map<String, dynamic>> converted_data = data.map((e) {
        var element = e as Map<String, dynamic>;
        total += element['point_value'];
        min_power = min(min_power, element['point_value']);
        max_power = max(max_power, element['point_value']);
        return element;
      }).toList();

      emit(UnitAnalysisLodingSuccessState(
          dataPoints: converted_data,
          total: total,
          max_value: max_power,
          min_value: min_power));
    } catch (e) {
      print(e);
    }
  }
}
