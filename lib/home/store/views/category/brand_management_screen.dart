import 'package:flutter/material.dart';
class BrandManagementScreen extends StatefulWidget {
  const BrandManagementScreen({Key? key}) : super(key: key);

  @override
  _BrandManagementScreenState createState() => _BrandManagementScreenState();
}

class _BrandManagementScreenState extends State<BrandManagementScreen> {
  final Map<String, List<String>> _brandsByCategory = {
    'phone': [
      'Apple',
      'Samsung',
      'Sony',
      'LG',
      'Panasonic',
      'Dell',
      'HP',
      'Lenovo',
      'Asus',
      'Acer',
      'Huawei',
      'Xiaomi',
      'Philips',
      'Bose',
      'Canon',
      'Nikon'
    ],
    'womens_tops': [
      'Nike',
      'Adidas',
      'H&M',
      'Gucci',
      'Louis Vuitton',
      'Uniqlo',
      'Levi\'s',
      'Gap',
      'Puma',
      'Ralph Lauren',
      'Tommy Hilfiger',
      'Lacoste'
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _initializeBrands(context),
            child: const Icon(Icons.playlist_add),
            heroTag: 'initializeBrands',
            tooltip: 'Бардык бренддерди кошуу',
          ),
        ],
      ),
    );
  }

  void _initializeBrands(BuildContext context) {
    // context
    //     .read<BrandBloc>()
    //     .add(InitializeBrands(brandsByCategory: _brandsByCategory));
  }
}
