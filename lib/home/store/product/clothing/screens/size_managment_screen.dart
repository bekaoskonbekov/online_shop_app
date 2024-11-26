import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/home/store/product/clothing/blocs/sizes/size_bloc.dart';
import 'package:my_example_file/home/store/product/clothing/blocs/sizes/size_event.dart';
import 'package:my_example_file/home/store/product/clothing/blocs/sizes/size_state.dart';
import 'package:my_example_file/home/store/product/clothing/models/size_model.dart';

class SizeManagementScreen extends StatefulWidget {
  const SizeManagementScreen({Key? key}) : super(key: key);
  @override
  _SizeManagementScreenState createState() => _SizeManagementScreenState();
}
class _SizeManagementScreenState extends State<SizeManagementScreen> {
  final List<Map<String, dynamic>> _initialSizes = [
    {
      'name': 'XS',
      'measurements': {'chest': 80, 'waist': 60, 'hips': 86}
    },
    {
      'name': 'S',
      'measurements': {'chest': 84, 'waist': 64, 'hips': 90}
    },
    {
      'name': 'M',
      'measurements': {'chest': 88, 'waist': 68, 'hips': 94}
    },
    {
      'name': 'L',
      'measurements': {'chest': 92, 'waist': 72, 'hips': 98}
    },
    {
      'name': 'XL',
      'measurements': {'chest': 96, 'waist': 76, 'hips': 102}
    },
  ];

  @override
  void initState() {
    super.initState();
    context.read<SizeBloc>().add(GetSizes());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Өлчөмдөр'),
      ),
      body: BlocConsumer<SizeBloc, SizeState>(
        listener: (context, state) {
          if (state is SizeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Ката: ${state.message}')),
            );
          } else if (state is SizeInitialized) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Өлчөмдөр ийгиликтүү кошулду')),
            );
            context.read<SizeBloc>().add(GetSizes());
          }
        },
        builder: (context, state) {
          if (state is SizeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is SizesLoaded) {
            return _buildSizeList(state.sizes);
          }
          return const Center(child: Text('Өлчөмдөр жүктөлгөн жок'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _initializeSizes(context),
        child: const Icon(Icons.playlist_add),
        tooltip: 'Бардык өлчөмдөрдү кошуу',
      ),
    );
  }

  Widget _buildSizeList(List<SizeModel> sizes) {
    return ListView.builder(
      itemCount: sizes.length,
      itemBuilder: (context, index) {
        final size = sizes[index];
        return ListTile(
          title: Text(size.name),
          subtitle: Text('Өлчөмдөр: ${size.measurements.toString()}'),
        );
      },
    );
  }
  void _initializeSizes(BuildContext context) {
    context.read<SizeBloc>().add(InitializeSizes(_initialSizes));
  }
}