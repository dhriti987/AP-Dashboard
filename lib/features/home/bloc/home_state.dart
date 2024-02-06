part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

sealed class HomeActionState extends HomeState {}

final class HomeInitial extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeLoadingFailedState extends HomeState {
  final ApiException apiException;

  HomeLoadingFailedState({required this.apiException});
}

class HomeLoadingSuccessState extends HomeState {
  final List<Plant> plants;

  HomeLoadingSuccessState({required this.plants});
}

class NavigateToSettingsPageActionState extends HomeActionState {}

class NavigateToDashboardPageActionState extends HomeActionState {
  final Plant plant;

  NavigateToDashboardPageActionState({required this.plant});
}

class LogoutSuccessState extends HomeActionState {}
