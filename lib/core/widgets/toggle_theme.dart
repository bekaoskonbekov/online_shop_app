
import 'package:flutter/material.dart';
import 'package:my_example_file/blocs/app/app_bloc.dart';
import 'package:my_example_file/blocs/app/app_event.dart';
import 'package:my_example_file/blocs/app/app_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
class ThemeToggle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppStateBloc, AppState>(
      builder: (context, state) {
        IconData icon;
        String tooltip;

        switch (state.themeMode) {
          case ThemeMode.light:
            icon = Icons.dark_mode;
            tooltip = 'Караңгы режимге которуу';
            break;
          case ThemeMode.dark:
            icon = Icons.light_mode;
            tooltip = 'Жарык режимге которуу';
            break;
          case ThemeMode.system:
          default:
            icon = Icons.brightness_auto;
            tooltip = 'Системанын темасын колдонуу';
            break;
        }

        return IconButton(
          icon: Icon(icon),
          tooltip: tooltip,
          onPressed: () {
            context.read<AppStateBloc>().add(ChangeTheme());
          },
        );
      },
    );
  }
}
