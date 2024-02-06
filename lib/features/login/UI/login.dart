import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:streaming_data_dashboard/features/login/bloc/login_bloc.dart';
import 'package:streaming_data_dashboard/service_locator.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final LoginBloc loginBloc = sl.get<LoginBloc>();
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String? usernameErrorText;
    String? passwordErrorText;

    return BlocConsumer<LoginBloc, LoginState>(
      bloc: loginBloc,
      listenWhen: (previous, current) => current is LoginActionState,
      buildWhen: (previous, current) => current is! LoginActionState,
      listener: (context, state) {
        if (state is LoginFailedState) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text(state.exception.error[0]),
                content: Text(state.exception.error[1]),
              );
            },
          );
        }
        if (state is LoginSuccessState) {
          context.go('/');
        }
      },
      builder: (context, state) {
        if (state is UsernameValidationFailedState) {
          usernameErrorText = state.error;
        }
        if (state is PasswordValidationFailedState) {
          passwordErrorText = state.error;
        }
        return Scaffold(
          appBar: AppBar(
            title: Text('Login Screen',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
            centerTitle: true,
            backgroundColor: Colors.blue,
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        child: Image.network(
                            'https://upload.wikimedia.org/wikipedia/commons/3/33/Adani-power-logo.png'),
                      )),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Form(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width / 3),
                            child: TextFormField(
                              controller: _username,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Username',
                                hintText: 'Enter username',
                                prefixIcon: Icon(Icons.person_2_sharp),
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                                errorText: usernameErrorText,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width / 3),
                            child: TextFormField(
                              controller: _password,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter Password',
                                prefixIcon: Icon(Icons.password),
                                border: OutlineInputBorder(),
                                errorText: passwordErrorText,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width / 3),
                            child: MaterialButton(
                              minWidth: double.infinity,
                              onPressed: () {
                                loginBloc.add(LoginButtonOnClickedEvent(
                                    username: _username.text,
                                    password: _password.text));
                              },
                              child: Text('Login'),
                              color: Colors.blue,
                              textColor: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextButton(
                              onPressed: () {
                                // Add logic for "Forgot Password?"
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Coming soon!'),
                                  ),
                                );
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ))
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
