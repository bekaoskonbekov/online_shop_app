import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/home/store/product/clothing/blocs/sizes/size_bloc.dart';
import 'package:my_example_file/home/store/product/clothing/blocs/sizes/size_state.dart';
import 'package:my_example_file/home/store/product/clothing/models/size_model.dart';

class WomensBlouseShirtWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onSpecificationsChanged;
  final Map<String, dynamic> initialData;
  const WomensBlouseShirtWidget({
    Key? key,
    required this.onSpecificationsChanged,
    required this.initialData,
  }) : super(key: key);
  @override
  _WomensBlouseShirtWidgetState createState() => _WomensBlouseShirtWidgetState();
}
class _WomensBlouseShirtWidgetState extends State<WomensBlouseShirtWidget> {
  late Map<String, dynamic> _specifications;
  List<SizeModel> _selectedSizes = [];
  @override
  void initState() {
    super.initState();
    _specifications = Map.from(widget.initialData);
    // context.read<SizeBloc>().add(GetSizesByCategory('womens_tops'));
  }

  void _updateSpecifications() {
    _specifications['sizes'] = _selectedSizes.map((size) => size.toMap()).toList();
    widget.onSpecificationsChanged(_specifications);
  }
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSizeDropdown(),
          SizedBox(height: 16),
          _buildTextField('Паттерн', 'pattern'),
          _buildTextField('Фит', 'fit'),
          _buildTextField('Сезон', 'season'),
          _buildTextField('Стиль', 'style'),
          _buildTextField('Окуя', 'occasion'),
          _buildTextField('Калыңдык', 'thickness'),
          _buildTextField('Тунуктук', 'transparency'),
          _buildTextField('Өзгөчөлүктөр', 'features'),
          _buildTextField('Коллекция аты', 'collectionName'),
          _buildTextField('Сертификаттар', 'certifications'),
          _buildTextField('Модель бойу (см)', 'modelHeight'),
          _buildTextField('Принт', 'print'),
          _buildTextField('Жең түрү', 'sleeveType'),
          _buildTextField('Материал курамы', 'materialComposition'),
        ],
      ),
    );
  }
 Widget _buildSizeDropdown() {
  return BlocBuilder<SizeBloc, SizeState>(
    builder: (context, state) {
      if (state is SizeLoading) {
        return Center(child: CircularProgressIndicator());
      } else if (state is SizesLoaded) {
        List<SizeModel> sizes = state.sizes;
        if (sizes.isEmpty) {
          return Text('Учурдагы категория үчүн өлчөмдөр табылган жок');
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Өлчөмдөр:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: sizes.map((size) {
                bool isSelected = _selectedSizes.contains(size);
                return FilterChip(
                  label: Text(size.name),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _selectedSizes.add(size);
                      } else {
                        _selectedSizes.remove(size);
                      }
                      _updateSpecifications();
                    });
                  },
                  backgroundColor: Colors.grey[200],
                  selectedColor: Colors.blue,
                  checkmarkColor: Colors.white,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                );
              }).toList(),
            ),
          ],
        );
      } else if (state is SizeError) {
        return Text('Ката: ${state.message}');
      } else {
        return Text('Күтүлбөгөн абал: $state');
      }
    },
  );
}
  Widget _buildTextField(String label, String field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        initialValue: _specifications[field]?.toString() ?? '',
        onChanged: (value) {
          setState(() {
            if (field == 'features' || field == 'certifications') {
              _specifications[field] = value.split(',').map((e) => e.trim()).toList();
            } else if (field == 'modelHeight') {
              _specifications[field] = int.tryParse(value);
            } else {
              _specifications[field] = value;
            }
            _updateSpecifications();
          });
        },
      ),
    );
  }
}