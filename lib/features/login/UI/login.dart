import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Screen'),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 144, 93, 179),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Adani',
                style: TextStyle(
                  fontSize: 45,
                  color: Colors.teal,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Pacifico',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Form(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 500),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            hintText: 'Enter email',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          onChanged: (String value) {},
                          validator: (value) {
                            return value!.isEmpty ? 'Please enter email' : null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 500),
                        child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            hintText: 'Enter Password',
                            prefixIcon: Icon(Icons.password),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (String value) {},
                          validator: (value) {
                            return value!.isEmpty
                                ? 'Please enter Password'
                                : null;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 500),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          onPressed: () {},
                          child: Text('Login'),
                          color: Colors.teal,
                          textColor: Colors.white,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      TextButton(
                          onPressed: () {
                            // Add logic for "Forgot Password?"
                            print("Forgot Password?");
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.teal,
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
  }
}
