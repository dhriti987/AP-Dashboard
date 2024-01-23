part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

sealed class LoginActionState extends LoginState {}

final class LoginInitial extends LoginState {}

class PasswordValidationFailedState extends LoginState {
  final String error;

  PasswordValidationFailedState({required this.error});
}

class UsernameValidationFailedState extends LoginState {
  final String error;

  UsernameValidationFailedState({required this.error});
}

class LoginFailedState extends LoginActionState {
  final ApiException exception;

  LoginFailedState({required this.exception});
}

class LoginSuccessState extends LoginActionState {}
