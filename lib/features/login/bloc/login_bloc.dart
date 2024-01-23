import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:streaming_data_dashboard/core/exceptions/api_exceptions.dart';
import 'package:streaming_data_dashboard/core/utilities/validators.dart';
import 'package:streaming_data_dashboard/features/login/repository/login_repository.dart';
import 'package:streaming_data_dashboard/service_locator.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository _loginRepository = sl.get<LoginRepository>();
  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<LoginButtonOnClickedEvent>(loginButtonOnClickedEvent);
  }

  FutureOr<void> loginButtonOnClickedEvent(
      LoginButtonOnClickedEvent event, Emitter<LoginState> emit) async {
    if (!minimumLengthValidator(event.password, 8)) {
      emit(PasswordValidationFailedState(
          error: "Password length should be atleast 8 characters"));
      return;
    }
    try {
      await _loginRepository.login(event.username, event.password);
      emit(LoginSuccessState());
    } on ApiException catch (e) {
      print("error aaya");
      emit(LoginFailedState(exception: e));
    }
  }
}
