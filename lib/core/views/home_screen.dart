import 'package:flutter/material.dart';
import 'package:my_example_file/auth/views/login_page.dart';
import 'package:my_example_file/blocs/app/app_bloc.dart';
import 'package:my_example_file/blocs/app/app_state.dart';
import 'package:my_example_file/blocs/auth/auth_bloc.dart';
import 'package:my_example_file/blocs/auth/auth_event.dart';
import 'package:my_example_file/blocs/auth/auth_state.dart';
import 'package:my_example_file/core/widgets/lang_toggle.dart';
import 'package:my_example_file/generated/locale_keys.g.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

import '../widgets/toggle_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.hello_world.tr()),
        actions: [ThemeToggle()],
        leading: LanguageToggle(),
      ),
      body: BlocBuilder<AppStateBloc, AppState>(
        builder: (context, state) {
          return Column(
            children: [
      
 
            
              Center(
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is Authenticated) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Welcome, ${state.user.name}!'),
                            SizedBox(height: 20),
                            ElevatedButton(
                              child: Text('Sign Out'),
                              onPressed: () {
                                context
                                    .read<AuthBloc>()
                                    .add(SignOutRequested());
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => LoginPage()));
                              },
                            ),
                          ],
                        ),
                      );
                    }
                    return Center(child: Text('Not authenticated'));
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
