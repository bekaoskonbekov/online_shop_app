import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/blocs/auth/auth_bloc.dart';
import 'package:my_example_file/blocs/auth/auth_event.dart';

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) => value!.isEmpty ? 'Enter an email' : null,
          ),
          TextFormField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) => value!.isEmpty ? 'Enter a password' : null,
          ),
          SizedBox(height: 20),
          Column(
            children: [
              ElevatedButton(
                child: Text('Sign In'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<AuthBloc>().add(SignInRequested(
                          _emailController.text,
                          _passwordController.text,
                        ));
                  }
                },
              ),
          SizedBox(height: 20),

              ElevatedButton(
                child: Text('Sign in with Google'),
                onPressed: () {
                  context.read<AuthBloc>().add(GoogleSignInRequested());
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
