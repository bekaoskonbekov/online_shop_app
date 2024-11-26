// lib/presentation/widgets/signup_form.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/blocs/auth/auth_bloc.dart';
import 'package:my_example_file/blocs/auth/auth_event.dart';

class SignUpForm extends StatefulWidget {
  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           TextFormField(
            controller: _nameController,
            decoration: InputDecoration(labelText: 'name'),
            validator: (value) => value!.isEmpty ? 'Enter a name' : null,
          ),
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
          ElevatedButton(
            child: Text('Sign Up'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<AuthBloc>().add(SignUpRequested(
                  _emailController.text,
                  _passwordController.text,
                  _nameController.text,
                ));
              }
            },
          ),
        ],
      ),
    );
  }
}