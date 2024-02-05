part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardState {}

sealed class DashboardActionState extends DashboardState {}

final class DashboardInitial extends DashboardState {}

class DashboardLoadingState extends DashboardState {}

class DashboardLoadingFailedState extends DashboardState {
  final ApiException apiException;

  DashboardLoadingFailedState({required this.apiException});
}

class DashboardLoadingSuccessState extends DashboardState {
  final List<Unit> units;
  final double frequency;
  final double totalValue;
  final double maxValue;

  DashboardLoadingSuccessState(
      {required this.units,
      required this.frequency,
      required this.totalValue,
      required this.maxValue});
}

class UnitAnalysisLodingState extends DashboardState {}

class UnitAnalysisLodingSuccessState extends DashboardState {
  final List<Map<String, dynamic>> dataPoints;
  final double total;
  final double max_value;
  final double min_value;

  UnitAnalysisLodingSuccessState(
      {required this.dataPoints,
      required this.total,
      required this.max_value,
      required this.min_value});
}

class UnitAnalysisLodingFailedState extends DashboardState {
  final ApiException apiException;

  UnitAnalysisLodingFailedState({required this.apiException});
}
