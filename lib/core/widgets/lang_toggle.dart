import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/blocs/app/app_bloc.dart';
import 'package:my_example_file/blocs/app/app_event.dart';
import 'package:my_example_file/blocs/app/app_state.dart';

class LanguageToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppStateBloc, AppState>(
      builder: (context, state) {
        return PopupMenuButton<Locale>(
          icon: Icon(Icons.language),
          onSelected: (Locale locale) {
            context.read<AppStateBloc>().add(ChangeLanguage(locale, context));
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
            PopupMenuItem<Locale>(
              value: Locale('ky', 'KG'),
              child: Text('Кыргызча'),
            ),
            PopupMenuItem<Locale>(
              value: Locale('ru', 'RU'),
              child: Text('Русский'),
            ),
            PopupMenuItem<Locale>(
              value: Locale('en', 'EN'),
              child: Text('English'),
            ),
          ],
        );
      },
    );
  }
}