import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'units_edit_event.dart';
part 'units_edit_state.dart';

class UnitsEditBloc extends Bloc<UnitsEditEvent, UnitsEditState> {
  UnitsEditBloc() : super(UnitsEditInitial()) {
    on<UnitsEditEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
