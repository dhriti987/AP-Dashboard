part of 'units_edit_bloc.dart';

@immutable
sealed class UnitsEditState extends Equatable {}

final class UnitsEditInitial extends UnitsEditState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

sealed class UnitEditActionState extends UnitsEditState {}

class UnitEditLoadingState extends UnitsEditState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class UnitEditLoadingFailedState extends UnitsEditState {
  final ApiException apiException;

  UnitEditLoadingFailedState({required this.apiException});

  @override
  // TODO: implement props
  List<Object?> get props => [apiException];
}

class UnitEditLoadingSuccessState extends UnitsEditState {
  final List<Unit> units;

  UnitEditLoadingSuccessState({required this.units});

  @override
  // TODO: implement props
  List<Object?> get props => [units];
}

class UnitEditErrorState extends UnitEditActionState {
  final ApiException apiException;

  UnitEditErrorState({required this.apiException});

  @override
  // TODO: implement props
  List<Object?> get props => [apiException];
}

class UnitAddedState extends UnitsEditState {
  final Unit unit;

  UnitAddedState({required this.unit});

  @override
  // TODO: implement props
  List<Object?> get props => [unit];
}

class UnitDeleteSuccessState extends UnitsEditState {
  final Unit unit;

  UnitDeleteSuccessState({required this.unit});

  @override
  // TODO: implement props
  List<Object?> get props => [unit];
}

class UnitEditSuccessState extends UnitsEditState {
  final Unit unit;

  UnitEditSuccessState({required this.unit});

  @override
  // TODO: implement props
  List<Object?> get props => [unit];
}

class AddUnitButtonClickedState extends UnitEditActionState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class EditUnitButtonClickedState extends UnitEditActionState {
  final Unit unit;

  EditUnitButtonClickedState({required this.unit});

  @override
  // TODO: implement props
  List<Object?> get props => [unit];
}
