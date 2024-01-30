part of 'units_edit_bloc.dart';

@immutable
sealed class UnitsEditEvent {}

class FetchUnitDataEvent extends UnitsEditEvent {
  final String plantName;

  FetchUnitDataEvent({required this.plantName});
}
