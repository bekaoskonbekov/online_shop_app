import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/home/store/models/product/product_params.dart';
import 'package:my_example_file/home/store/product/electronics/blocs/electronics_bloc.dart';
import 'package:my_example_file/home/store/product/electronics/blocs/electronics_event.dart';
import 'package:my_example_file/home/store/product/electronics/blocs/electronics_state.dart';
import 'package:my_example_file/home/store/product/electronics/models/OS_model.dart';

class ElectronicsWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onSpecificationsChanged;
  final Map<String, dynamic> initialData;
  final ProductParams productParams;

  const ElectronicsWidget({
    Key? key,
    required this.onSpecificationsChanged,
    required this.initialData,
    required this.productParams,
  }) : super(key: key);

  @override
  _ElectronicsWidgetState createState() => _ElectronicsWidgetState();
}

class _ElectronicsWidgetState extends State<ElectronicsWidget> {
  late Map<String, dynamic> _specifications;
  OperatingSystemModel? _selectedOS;
  OSVersion? _selectedOSVersion;

  @override
  void initState() {
    super.initState();
    _specifications = Map.from(widget.initialData);
    _loadOperatingSystems();
  }

  void _loadOperatingSystems() {
    context.read<ElectronicsBloc>().add(GetOperatingSystems());
  }

  void _updateSpecifications() {
    final category = widget.productParams.category;
    if (category?.categoryType != 'laptop' && _selectedOS != null && _selectedOSVersion != null) {
      _specifications['operatingSystem'] = {
        'osId': _selectedOS!.osId,
        'name': _selectedOS!.name,
        'version': _selectedOSVersion!.number,
        'releaseDateYear': _selectedOSVersion!.releaseDateYear,
        'productType': _selectedOS!.productType,
        'productIds': _selectedOS!.productIds,
      };
      
      _addProductToOS();
    } else {
      _specifications['operatingSystem'] = null;
    }
    widget.onSpecificationsChanged(_specifications);
  }

  void _addProductToOS() {
    final productId = widget.productParams.productId;
    if (productId != null && productId.isNotEmpty && _selectedOS != null) {
      context.read<ElectronicsBloc>().add(AddProductToOS(productId, _selectedOS!.osId));
    } else {
      print('Warning: Unable to add product to OS. ProductId or SelectedOS is null or empty.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ElectronicsBloc, ElectronicsState>(
      listener: (context, state) {
        if (state is ElectronicsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Ката: ${state.message}')),
          );
        } else if (state is ProductAddedToOS) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Продукт ОСке ийгиликтүү кошулду')),
          );
        }
      },
      builder: (context, state) {
        if (state is ElectronicsLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is OperatingSystemsLoaded) {
          return _buildOSDropdowns(state.operatingSystems);
        } else {
          return _buildOSDropdowns({});
        }
      },
    );
  }

  Widget _buildOSDropdowns(Map<String, List<OperatingSystemModel>> osMap) {
    final productType = widget.productParams.category?.productType;
    List<OperatingSystemModel> filteredOSList = productType != null ? osMap[productType] ?? [] : [];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOSDropdown(filteredOSList),
        SizedBox(height: 16),
        if (_selectedOS != null) _buildOSVersionDropdown(),
      ],
    );
  }

  Widget _buildOSDropdown(List<OperatingSystemModel> osList) {
    return DropdownButtonFormField<OperatingSystemModel>(
      decoration: InputDecoration(
        labelText: 'Операциялык система',
        border: OutlineInputBorder(),
      ),
      value: _selectedOS,
      items: osList.map((os) {
        return DropdownMenuItem<OperatingSystemModel>(
          value: os,
          child: Text(os.name),
        );
      }).toList(),
      onChanged: (OperatingSystemModel? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedOS = newValue;
            _selectedOSVersion = null;
            _updateSpecifications();
          });
        }
      },
    );
  }

  Widget _buildOSVersionDropdown() {
    return DropdownButtonFormField<OSVersion>(
      decoration: InputDecoration(
        labelText: 'Версия',
        border: OutlineInputBorder(),
      ),
      value: _selectedOSVersion,
      items: _selectedOS!.versions.map((version) {
        return DropdownMenuItem<OSVersion>(
          value: version,
          child: Text('${version.number} (${version.releaseDateYear})'),
        );
      }).toList(),
      onChanged: (OSVersion? newValue) {
        if (newValue != null) {
          setState(() {
            _selectedOSVersion = newValue;
            _updateSpecifications();
          });
        }
      },
    );
  }
}