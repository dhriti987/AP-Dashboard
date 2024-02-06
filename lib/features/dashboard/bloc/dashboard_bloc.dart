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
    on<NavigateToUnitAnalysisPageEvent>(onNavigateToUnitAnalysisPageEvent);
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
          frequency: 0,
          totalValue: totalValue,
          maxValue: maxValue));
    } on ApiException catch (e) {
      emit(DashboardLoadingFailedState(apiException: e));
    }
  }

  FutureOr<void> onUnitValueChangedEvent(
      UnitValueChangedEvent event, Emitter<DashboardState> emit) {
    try {
      Map<String, dynamic> pointData = json.decode(event.data);
      double totalValue = 0;
      double maxValue = 0;
      for (var element in event.units) {
        final index = pointData["data"]
            .indexWhere((e) => e["pointId"] == element.pointId);
        element.unitValue = pointData["data"][index]["pointValues"];
        totalValue += element.unitValue;
        maxValue += element.maxVoltage;
      }
      emit(DashboardLoadingSuccessState(
          units: event.units,
          frequency: pointData["frequency"],
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
      Map<String, dynamic> data =
          await _unitAnalysisRepository.getUnit24hrData(event.unitId);
      List<dynamic> unitData = data["unit_data"];
      double total = 0;
      double minPower = double.infinity;
      double maxPower = double.negativeInfinity;
      List<Map<String, dynamic>> convertedData = unitData.map((e) {
        var element = e as Map<String, dynamic>;
        total += element['point_value'];
        minPower = min(minPower, element['point_value']);
        maxPower = max(maxPower, element['point_value']);
        return element;
      }).toList();

      emit(UnitAnalysisLodingSuccessState(
          frequencyPoints: (data["frequency"] as List<dynamic>)
              .map((e) => e as Map<String, dynamic>)
              .toList(),
          dataPoints: convertedData,
          total: total,
          max_value: maxPower,
          min_value: minPower));
    } catch (e) {
      print(e);
    }
  }

  FutureOr<void> onNavigateToUnitAnalysisPageEvent(
      NavigateToUnitAnalysisPageEvent event, Emitter<DashboardState> emit) {
    emit(NavigateToUnitAnalysisPageState(unit: event.unit));
  }
}
