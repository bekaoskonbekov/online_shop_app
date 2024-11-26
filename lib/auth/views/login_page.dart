import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/auth/views/login_form.dart';
import 'package:my_example_file/auth/views/sign_up_page.dart';
import 'package:my_example_file/blocs/auth/auth_bloc.dart';
import 'package:my_example_file/blocs/auth/auth_state.dart';
import 'package:my_example_file/core/views/main_screen.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Column(
        children: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is Authenticated) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => MainScreen()),
                );
              }
              if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message)),
                );
              }
            },
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                if (state is AuthLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                return Center(child: LoginForm());
              },
            ),
            
           
          ),
           const SizedBox(height: 20),
            TextButton(
              child: Text('Don\'t have an account? Sign Up'),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => SignUpPage()),
                );
              },
            ),
        ],
      ),
    );
  }
}