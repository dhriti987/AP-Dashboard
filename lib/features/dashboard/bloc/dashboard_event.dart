part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardEvent {}

class FetchUnitDataEvent extends DashboardEvent {
  final String plantName;

  FetchUnitDataEvent({required this.plantName});
}

class UnitValueChangedEvent extends DashboardEvent {
  final List<Unit> units;
  final String data;

  UnitValueChangedEvent({required this.units, required this.data});
}

class FetchDatapointsEvent extends DashboardEvent {
  final int unitId;

  FetchDatapointsEvent({required this.unitId});
}

class NavigateToUnitAnalysisPageEvent extends DashboardEvent {
  final int unit;

  NavigateToUnitAnalysisPageEvent({required this.unit});
}
