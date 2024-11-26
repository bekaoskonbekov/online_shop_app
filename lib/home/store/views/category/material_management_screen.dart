import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/home/store/bloc/material/material_bloc.dart';
import 'package:my_example_file/home/store/bloc/material/material_event.dart';

class MaterialManagementScreen extends StatefulWidget {
  const MaterialManagementScreen({Key? key}) : super(key: key);

  @override
  _MaterialManagementScreenState createState() => _MaterialManagementScreenState();
}

class _MaterialManagementScreenState extends State<MaterialManagementScreen> {
  final Map<String, List<String>> _materialsByCategory = {
    'womens_tops': [
      'Cotton', 'Silk', 'Wool', 'Linen', 'Polyester', 'Nylon', 'Denim'
    ],
    'phone': [
      'Plastic', 'Metal', 'Glass', 'Silicon', 'Copper', 'Aluminum', 'Rubber'
    ],
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _initializeMaterials(context),
        child: const Icon(Icons.playlist_add),
      ),
    );
  }
  void _initializeMaterials(BuildContext context) {
    context.read<MaterialBloc>().add(InitializeMaterials(materialsByCategory: _materialsByCategory));
  }
}