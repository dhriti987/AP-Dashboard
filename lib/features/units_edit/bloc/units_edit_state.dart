part of 'units_edit_bloc.dart';

@immutable
sealed class UnitsEditState {}

final class UnitsEditInitial extends UnitsEditState {}

sealed class UnitEditActionState extends UnitsEditState {}

class UnitEditLoadingState extends UnitsEditState {}

class UnitEditLoadingFailedState extends UnitsEditState {
  final ApiException apiException;

  UnitEditLoadingFailedState({required this.apiException});
}

class UnitEditLoadingSuccessState extends UnitsEditState {
  final List<Unit> units;

  UnitEditLoadingSuccessState({required this.units});
}
