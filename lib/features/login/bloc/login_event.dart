part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginButtonOnClickedEvent extends LoginEvent {
  final String username;
  final String password;

  LoginButtonOnClickedEvent({required this.username, required this.password});
}
