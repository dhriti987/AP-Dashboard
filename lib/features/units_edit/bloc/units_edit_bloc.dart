import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:streaming_data_dashboard/core/exceptions/api_exceptions.dart';
import 'package:streaming_data_dashboard/features/units_edit/repository/unit_edit_repository.dart';
import 'package:streaming_data_dashboard/models/plant_model.dart';
import 'package:streaming_data_dashboard/models/unit_model.dart';
import 'package:streaming_data_dashboard/service_locator.dart';

part 'units_edit_event.dart';
part 'units_edit_state.dart';

class UnitsEditBloc extends Bloc<UnitsEditEvent, UnitsEditState> {
  final UnitEditRepository _unitEditRepository = sl.get<UnitEditRepository>();

  UnitsEditBloc() : super(UnitsEditInitial()) {
    on<UnitsEditEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<FetchUnitDataEvent>(onFetchUnitDataEvent);
    on<AddUnitEvent>(onAddUnitEvent);
    on<EditUnitEvent>(onEditUnitEvent);
    on<DeleteUnitEvent>(onDeleteUnitEvent);
    on<ClickAddUnitEvent>(onClickAddUnitEvent);
    on<ClickEditUnitEvent>(onClickEditUnitEvent);
  }

  FutureOr<void> onFetchUnitDataEvent(
      FetchUnitDataEvent event, Emitter<UnitsEditState> emit) async {
    emit(UnitEditLoadingState());
    try {
      var data = await _unitEditRepository.getAllUnitsByPlant(event.plantName);
      emit(UnitEditLoadingSuccessState(units: data));
    } on ApiException catch (e) {
      emit(UnitEditLoadingFailedState(apiException: e));
    }
  }

  Future<void> onAddUnitEvent(
      AddUnitEvent event, Emitter<UnitsEditState> emit) async {
    print("asdfgh");
    try {
      final data = await _unitEditRepository.addUnit(
          event.pointId,
          event.systemGuid,
          event.plant.id,
          event.unit,
          "${event.plant.name}_${event.unit}",
          event.ratedPower);
      emit(UnitAddedState(unit: data));
    } on ApiException catch (e) {
      emit(UnitEditErrorState(apiException: e));
    }
  }

  FutureOr<void> onDeleteUnitEvent(
      DeleteUnitEvent event, Emitter<UnitsEditState> emit) async {
    try {
      print("onDeleteUnitEvent");
      await _unitEditRepository.deleteUnit(event.unit.id);
      emit(UnitDeleteSuccessState(unit: event.unit));
    } on ApiException catch (e) {
      emit(UnitEditErrorState(apiException: e));
    }
  }

  FutureOr<void> onEditUnitEvent(
      EditUnitEvent event, Emitter<UnitsEditState> emit) async {
    emit(UnitEditLoadingState());
    try {
      final data = await _unitEditRepository.editUnit(event.unit);
      emit(UnitEditSuccessState(unit: data));
    } on ApiException catch (e) {
      emit(UnitEditErrorState(apiException: e));
    }
  }

  FutureOr<void> onClickAddUnitEvent(
      ClickAddUnitEvent event, Emitter<UnitsEditState> emit) {
    emit(AddUnitButtonClickedState());
  }

  FutureOr<void> onClickEditUnitEvent(
      ClickEditUnitEvent event, Emitter<UnitsEditState> emit) {
    emit(EditUnitButtonClickedState(unit: event.unit));
  }
}
