import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/home/store/bloc/product_bloc/product_bloc.dart';
import 'package:my_example_file/home/store/bloc/product_bloc/product_event.dart';
import 'package:my_example_file/home/store/bloc/product_bloc/product_state.dart';
import 'package:my_example_file/home/store/models/product/product_model.dart';
import 'package:my_example_file/home/store/models/product/product_params.dart';
import 'package:my_example_file/home/store/product/clothing/models/clothing_model.dart';
import 'package:my_example_file/home/store/product/clothing/models/size_model.dart';
import 'package:my_example_file/home/store/product/electronics/models/OS_model.dart';
import 'package:my_example_file/home/store/product/electronics/models/electronic_model.dart';
import 'package:my_example_file/home/store/views/product/screens/create_product/widgets/clothing/electronics_widget.dart';
import 'package:my_example_file/home/store/views/product/screens/create_product/widgets/clothing/womens_tops_widget.dart';
class CreateProductSpecificationScreen extends StatefulWidget {
  final ProductParams creationData;
  const CreateProductSpecificationScreen({
    Key? key,
    required this.creationData,
  }) : super(key: key);
  @override
  _CreateProductSpecificationScreenState createState() =>
      _CreateProductSpecificationScreenState();
}

class _CreateProductSpecificationScreenState
    extends State<CreateProductSpecificationScreen> {
  final _formKey = GlobalKey<FormState>();
  late Map<String, dynamic> _specificationsData;
  @override
  void initState() {
    super.initState();
    _specificationsData = {};
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Продукттун сыпаттамалары'),
      ),
      body: BlocListener<ProductBloc, ProductState>(
        listener: _handleProductBlocState,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductSpecificationWidget(),
                SizedBox(height: 32),
                ElevatedButton(
                  child: Text('Продуктту түзүү'),
                  onPressed: _submitForm,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void _handleProductBlocState(BuildContext context, ProductState state) {
    if (state is ProductLoaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Продукт ийгиликтүү түзүлдү!')),
      );
      Navigator.popUntil(context, (route) => route.isFirst);
    } else if (state is ProductError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ката: ${state.message}')),
      );
    }
  }
  Widget _buildProductSpecificationWidget() {
    final categoryType = widget.creationData.category?.categoryType.toLowerCase();
    final productType = widget.creationData.category?.productType?.toLowerCase() ?? categoryType;
    
    if (categoryType == 'electronics' || productType == 'phone' || productType == 'laptop') {
      return ElectronicsWidget(
        onSpecificationsChanged: (specs) {
          setState(() {
            _specificationsData = specs;
          });
        },
        initialData: _specificationsData,
        productParams: widget.creationData,
      );
    } else if (categoryType == 'clothing' || productType == 'womens_tops') {
      return WomensBlouseShirtWidget(
        onSpecificationsChanged: (specs) {
          setState(() {
            _specificationsData = specs;
          });
        },
        initialData: _specificationsData,
      );
    } else {
      return Container();
    }
  }
  Widget _buildTextField(String label, String field) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        initialValue: _specificationsData[field]?.toString() ?? '',
        onChanged: (value) {
          setState(() {
            _specificationsData[field] = value;
          });
        },
      ),
    );
  }
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      try {
        final product = _createProduct();
        context.read<ProductBloc>().add(CreateProduct(product: product));
      } catch (e) {
        print('Error in _submitForm: $e'); // Debugging line
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ката: $e')),
        );
      }
    }
  }

  ProductModel _createProduct() {
    final baseFields = widget.creationData;
    final categoryType = baseFields.category?.categoryType.toLowerCase();
    final productType =
        baseFields.category?.productType?.toLowerCase() ?? categoryType;
    if (categoryType == 'electronics' ||
        productType == 'phone' ||
        productType == 'laptop') {
      final osData =
          _specificationsData['operatingSystem'] as Map<String, dynamic>?;
      final operatingSystem = osData != null
          ? OperatingSystemModel.fromMap(osData, osData['osId'] ?? '')
          : null;

      if (operatingSystem == null) {
        throw Exception(
            'Операциялык система маалыматтары жок же туура эмес форматта.');
      }
      return ElectronicsModel(
        params: baseFields,
        electronicsId: '',
      productType: productType!,
        operatingSystem: operatingSystem,
      );
    } else if (categoryType == 'clothing' || productType == 'womens_tops') {
      final sizesData = _specificationsData['sizes'] as List<dynamic>?;
      final sizes = sizesData != null
          ? sizesData
              .map((sizeData) =>
                  SizeModel.fromMap(sizeData as Map<String, dynamic>))
              .toList()
          : <SizeModel>[];
      return ClothingModel(
        params: baseFields,
        clothingId: '',
        sizes: sizes,
      );
    } else {
      return ProductModel(
        params: baseFields.copyWith(
          name: _specificationsData['name'] ?? baseFields.name,
          description:
              _specificationsData['description'] ?? baseFields.description,
          price: double.tryParse(_specificationsData['price'] ?? '') ??
              baseFields.price,
        ),
      );
    }
  }
}
