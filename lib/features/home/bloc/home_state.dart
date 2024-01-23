part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

sealed class HomeActionState extends HomeState {}

final class HomeInitial extends HomeState {}

class NavigateToSettingsPageActionState extends HomeActionState {}

class NavigateToDashboardPageActionState extends HomeActionState {
  final Plant plant;

  NavigateToDashboardPageActionState({required this.plant});
}
