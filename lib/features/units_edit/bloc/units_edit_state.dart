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

class UnitEditErrorState extends UnitEditActionState {
  final ApiException apiException;

  UnitEditErrorState({required this.apiException});
}

class UnitAddedState extends UnitsEditState {
  final Unit unit;

  UnitAddedState({required this.unit});
}

class UnitDeleteSuccessState extends UnitsEditState {
  final Unit unit;

  UnitDeleteSuccessState({required this.unit});
}
