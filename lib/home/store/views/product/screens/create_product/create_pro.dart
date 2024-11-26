import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/home/store/models/brand_model.dart';
import 'package:my_example_file/home/store/models/color_model.dart';
import 'package:my_example_file/home/store/models/country_of_origin_model.dart';
import 'package:my_example_file/home/store/models/material_model.dart';
import 'package:my_example_file/home/store/models/product/product_params.dart';
import 'package:my_example_file/home/store/views/product/screens/create_product/product_creation.dart';
import 'package:my_example_file/home/store/views/product/screens/create_product/spesification_screen.dart';

class CreateProductScreen extends StatefulWidget {
  final String categoryId;
  final String storeId;
  final List<String> imageUrls;

  const CreateProductScreen({
    Key? key,
    required this.categoryId,
    required this.storeId,
    required this.imageUrls,
  }) : super(key: key);

  @override
  _CreateProductScreenState createState() => _CreateProductScreenState();
}

class _CreateProductScreenState extends State<CreateProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, TextEditingController> _controllers = {
    'name': TextEditingController(),
    'description': TextEditingController(),
    'price': TextEditingController(),
    'stockQuantity': TextEditingController(),
    'transactionType': TextEditingController(),
    'promotion': TextEditingController(),
    'weight': TextEditingController(),
    'returnPolicy': TextEditingController(),
    'barcode': TextEditingController(),
    'length': TextEditingController(),
    'width': TextEditingController(),
    'height': TextEditingController(),
  };

  @override
  void initState() {
    super.initState();
    _initializeProductCreation();
  }

  void _initializeProductCreation() {
    context.read<ProductCreationBloc>().add(InitializeProductCreation(
          categoryId: widget.categoryId,
          storeId: widget.storeId,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Продукттун маалыматтары')),
      body: BlocConsumer<ProductCreationBloc, ProductCreationState>(
        listener: _handleProductCreationState,
        builder: (context, state) {
          if (state is ProductCreationLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return _buildForm(state);
        },
      ),
    );
  }

  void _handleProductCreationState(
      BuildContext context, ProductCreationState state) {
    if (state is ProductCreationError) {
      _showErrorSnackBar(context, state.message);
    } else if (state is ProductCreationSuccess) {
      _navigateToSpecificationScreen(context);
    }
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Widget _buildForm(ProductCreationState state) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._buildTextFields(),
            SizedBox(height: 16),
            if (state is ProductCreationReady) _buildDropdowns(state),
            SizedBox(height: 32),
            ElevatedButton(
              child: Text('Продукт түзүү'),
              onPressed: () => _submitForm(context),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTextFields() {
    return _controllers.entries.map((entry) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: TextFormField(
          controller: entry.value,
          decoration: InputDecoration(
            labelText: _getFieldLabel(entry.key),
            border: OutlineInputBorder(),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildDropdowns(ProductCreationReady state) {
    return Column(
      children: [
        _buildDropdown(
          label: 'Бренд',
          items: state.availableBrands,
          value: state.productData['brandId'] as String?,
          onChanged: (value) => _updateField('brandId', value),
          validator: (value) => value == null ? 'Брендди тандаңыз' : null,
        ),
        SizedBox(height: 16),
        _buildDropdown(
          label: 'Материал',
          items: state.availableMaterials,
          value: state.productData['materialId'] as String?,
          onChanged: (value) => _updateField('materialId', value),
          validator: (value) => value == null ? 'Материалды тандаңыз' : null,
        ),
        SizedBox(height: 16),
        _buildDropdown(
          label: 'Түс',
          items: state.availableColors,
          value: state.productData['colorId'] as String?,
          onChanged: (value) => _updateField('colorId', value),
          validator: (value) => value == null ? 'Түстү тандаңыз' : null,
        ),
        SizedBox(height: 16),
        _buildDropdown(
          label: 'Өндүрүлгөн өлкө',
          items: state.availableCountries,
          value: state.productData['countryId'] as String?,
          onChanged: (value) => _updateField('countryId', value),
          validator: (value) => value == null ? 'Өлкөнү тандаңыз' : null,
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required List<T> items,
    required String? value,
    required Function(String?) onChanged,
    required String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      decoration:
          InputDecoration(labelText: label, border: OutlineInputBorder()),
      value: value,
      items: items
          .map((item) => DropdownMenuItem(
              value: _getItemId(item), child: Text(_getItemName(item))))
          .toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  String _getItemId(dynamic item) {
    if (item is BrandModel) return item.brandId;
    if (item is MaterialModel) return item.materialId;
    if (item is ColorModel) return item.colorId;
    if (item is CountryOfOriginModel) return item.countryId;
    throw Exception('Unknown item type');
  }

  String _getItemName(dynamic item) {
    if (item is BrandModel) return item.name;
    if (item is MaterialModel) return item.name;
    if (item is ColorModel) return item.name;
    if (item is CountryOfOriginModel) return item.name;
    throw Exception('Unknown item type');
  }

  void _updateField(String field, String? value) {
    if (value != null) {
      context
          .read<ProductCreationBloc>()
          .add(UpdateProductField(field: field, value: value));
    }
  }

  String _getFieldLabel(String field) {
    final labels = {
      'name': 'Аталышы',
      'description': 'Сүрөттөмө',
      'price': 'Баасы',
      'stockQuantity': 'Саны',
      'transactionType': 'Бүтүм түрү',
      'promotion': 'Акция',
      'weight': 'Салмагы',
      'returnPolicy': 'Кайтаруу саясаты',
      'barcode': 'Штрих-код',
      'length': 'Узундугу',
      'width': 'Туурасы',
      'height': 'Бийиктиги',
    };
    return labels[field] ?? field;
  }
  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final data = _controllers.map((key, value) => MapEntry(key, value.text));
      final productFields = _createProductFields(data);
      context
          .read<ProductCreationBloc>()
          .add(SubmitProductCreation(productFields: productFields));
    }
  }
  ProductParams _createProductFields(Map<String, String> data) {
    final state = context.read<ProductCreationBloc>().state;
    if (state is! ProductCreationReady) {
      throw Exception('ProductCreationBloc is not in ready state');
    }
    return ProductParams(
      productId: '',
      storeId: widget.storeId,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: double.tryParse(data['price'] ?? '') ?? 0,
      imageUrls: widget.imageUrls,
      category: state.category,
      stockQuantity: int.tryParse(data['stockQuantity'] ?? '') ?? 0,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      transactionType: data['transactionType'] ?? '',
      promotion: double.tryParse(data['promotion'] ?? '') ?? 0,
      likes: [],
      comments: [],
      dimensions: {
        'length': double.tryParse(data['length'] ?? '') ?? 0,
        'width': double.tryParse(data['width'] ?? '') ?? 0,
        'height': double.tryParse(data['height'] ?? '') ?? 0,
      },
      weight: data['weight'] ?? '',
      brand: state.selectedBrand ??
          BrandModel(brandId: '', name: '', categoryType: ''),
      countryOfOrigin: state.selectedCountry ??
          CountryOfOriginModel(countryId: '', name: '', code: ''),
      returnPolicy: data['returnPolicy'] ?? '',
      colorOptions: state.selectedColor != null ? [state.selectedColor!] : [],
      barcode: data['barcode'] ?? '',
      materials:
          state.selectedMaterial != null ? [state.selectedMaterial!] : [],
    );
  }
  void _navigateToSpecificationScreen(BuildContext context) {
    final state = context.read<ProductCreationBloc>().state;
    if (state is ProductCreationSuccess) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateProductSpecificationScreen(
            creationData: state.productFields,
          ),
        ),
      );
    }
  }
  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    super.dispose();
  }
}
