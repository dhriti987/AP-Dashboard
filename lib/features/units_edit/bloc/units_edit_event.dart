part of 'units_edit_bloc.dart';

@immutable
sealed class UnitsEditEvent {}

class FetchUnitDataEvent extends UnitsEditEvent {
  final String plantName;

  FetchUnitDataEvent({required this.plantName});
}

class AddUnitEvent extends UnitsEditEvent {
  final Plant plant;
  final String pointId;
  final String systemGuid;
  final String unit;
  final String ratedPower;

  AddUnitEvent(
      {required this.plant,
      required this.pointId,
      required this.systemGuid,
      required this.unit,
      required this.ratedPower});
}

class DeleteUnitEvent extends UnitsEditEvent {
  final Unit unit;

  DeleteUnitEvent({required this.unit});
}

class EditUnitEvent extends UnitsEditEvent {
  final Unit unit;

  EditUnitEvent({required this.unit});
}

class ClickAddUnitEvent extends UnitsEditEvent {
  final Plant plant;

  ClickAddUnitEvent({required this.plant});
}

class ClickEditUnitEvent extends UnitsEditEvent {
  final Unit unit;

  ClickEditUnitEvent({required this.unit});
}
