import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/home/store/bloc/color/color_bloc.dart';
import 'package:my_example_file/home/store/bloc/color/color_event.dart';
class ColorManagementScreen extends StatefulWidget {
  const ColorManagementScreen({Key? key}) : super(key: key);
  @override
  _ColorManagementScreenState createState() => _ColorManagementScreenState();
}
class _ColorManagementScreenState extends State<ColorManagementScreen> {
  final List<Map<String, dynamic>> _colors = [
    {'name': 'Кара', 'colorValue': 0xFF000000},
    {'name': 'Ак', 'colorValue': 0xFFFFFFFF},
    {'name': 'Күмүш', 'colorValue': 0xFFC0C0C0},
    {'name': 'Алтын', 'colorValue': 0xFFFFD700},
    {'name': 'Кызыл', 'colorValue': 0xFFFF0000},
    {'name': 'Жашыл', 'colorValue': 0xFF00FF00},
    {'name': 'Көк', 'colorValue': 0xFF0000FF},
    {'name': 'Сары', 'colorValue': 0xFFFFFF00},
  ];
  @override
  void initState() {
    super.initState();
    context.read<ColorBloc>().add(GetColors());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _initializeColors(context),
        child: const Icon(Icons.palette),
        heroTag: 'initializeColors',
        tooltip: 'Бардык түстөрдү кошуу',
      ),
    );
  }
  void _initializeColors(BuildContext context) {
    context.read<ColorBloc>().add(InitializeColors(_colors));
  }
}