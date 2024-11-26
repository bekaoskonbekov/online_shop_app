import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:my_example_file/home/store/bloc/product_category/product_category_event.dart';
import 'package:my_example_file/home/store/bloc/product_category/product_category_state.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_example_file/home/store/bloc/product_category/product_category_bloc.dart';
import 'package:my_example_file/home/store/models/product_category.dart';

class CategoryManagementScreen extends StatefulWidget {
  const CategoryManagementScreen({Key? key}) : super(key: key);

  @override
  _CategoryManagementScreenState createState() => _CategoryManagementScreenState();
}

class _CategoryManagementScreenState extends State<CategoryManagementScreen> {
  final List<Map<String, dynamic>> _initialCategories = [
  {
    'name': 'Одежда',
    'categoryType': 'clothing',
    'image': 'assets/images/categories/clothing.jpg',
    'subcategories': [
      {
        'name': 'Женщинам',
        'categoryType': 'womens_clothing',
        'image': 'assets/images/categories/womens_clothing.jpg',
        'subcategories': [
          {
            'name': 'Блузы и рубашки',
            'categoryType': 'womens_tops',
            'productType': 'womens_tops',
            'image': 'assets/images/categories/womens_tops.jpg',
          },
          {
            'name': 'Платья',
            'categoryType': 'womens_dresses',
            'productType': 'womens_dresses',
            'image': 'assets/images/categories/womens_dresses.jpg',
          },
        ],
      },
      {
        'name': 'Мужчинам',
        'categoryType': 'mens_clothing',
        'image': 'assets/images/categories/mens_clothing.jpg',
        'subcategories': [
          {
            'name': 'Брюки',
            'categoryType': 'mens_pants',
            'productType': 'mens_pants',
            'image': 'assets/images/categories/mens_pants.jpg',
          },
          {
            'name': 'Рубашки',
            'categoryType': 'mens_shirts',
            'productType': 'mens_shirts',
            'image': 'assets/images/categories/mens_shirts.jpg',
          },
        ],
      },
    ],
  },
  {
    'name': 'Электроника',
    'categoryType': 'electronics',
    'image': 'assets/images/categories/electronics.jpg',
    'subcategories': [
      {
        'name': 'Компьютеры и планшеты',
        'categoryType': 'computers_and_tablets',
        'image': 'assets/images/categories/computers_and_tablets.jpg',
        'subcategories': [
          {
            'name': 'Ноутбуки',
            'categoryType': 'laptops',
            'productType': 'laptop',
            'image': 'assets/images/categories/laptops.jpg',
          },
          {
            'name': 'Игровые ноутбуки',
            'categoryType': 'gaming_laptops',
            'productType': 'gaming_laptop',
            'image': 'assets/images/categories/gaming_laptops.jpg',
          },
        ],
      },
      {
        'name': 'Телефоны и смарт-часы',
        'categoryType': 'phones_and_smartwatches',
        'image': 'assets/images/categories/phones_and_smartwatches.jpg',
        'subcategories': [
          {
            'name': 'Смартфоны',
            'categoryType': 'phone',
            'productType': 'phone',
            'image': 'assets/images/categories/smartphones.jpg',
          },
          {
            'name': 'Аксессуары для смартфонов',
            'categoryType': 'phone_accessories',
            'productType': 'phone_accessory',
            'image': 'assets/images/categories/phone_accessories.jpg',
          },
        ],
      },
    ],
  },
];
  bool _isInitialized = false;
  bool _isInitializing = false;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  void _loadCategories() {
    context.read<CategoryBloc>().add( GetCategories(parentCategoryId: '', depth: 2));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Категориялар'),
      ),
      body: BlocConsumer<CategoryBloc, CategoryState>(
        listener: _handleCategoryStateChanges,
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoriesLoaded) {
            return _buildCategoryList(state.categories);
          } else if (state is CategoryError) {
            return Center(child: Text('Ката: ${state.message}'));
          } else if (state is CategoryInitial) {
            context.read<CategoryBloc>().add(GetCategories(parentCategoryId: '', depth: 2));
            return const Center(child: CircularProgressIndicator());
          }
          return const Center(child: Text('Категориялар жүктөлгөн жок'));
        },
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }
   void _handleCategoryStateChanges(BuildContext context, CategoryState state) {
    if (state is CategoryError) {
      _showSnackBar(context, 'Ката: ${state.message}');
    } else if (state is CategoryOperationSuccess) {
      _showSnackBar(context, state.message);
      _loadCategories();
    } else if (state is CategoryCreated) {
      _showSnackBar(context, 'Жаңы категория түзүлдү: ${state.category.name}');
      _loadCategories();
    } else if (state is InitializeCategories) {
      _showSnackBar(context, 'Категориялар ийгиликтүү инициализацияланды');
      _loadCategories();
    }
  }
  Widget _buildCategoryList(List<ProductCategoryModel> categories) {
    if (categories.isEmpty) {
      return const Center(child: Text('Категориялар табылган жок'));
    }
    return ListView.builder(
      itemCount: categories.length,
      itemBuilder: (context, index) => _buildCategoryTile(categories[index]),
    );
  }
  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _isInitialized || _isInitializing ? null : () => _initializeCategories(context),
      child: _isInitializing 
        ? const CircularProgressIndicator(color: Colors.white)
        : Icon(_isInitialized ? Icons.check : Icons.playlist_add),
      tooltip: _isInitialized 
        ? 'Категориялар инициализацияланган' 
        : (_isInitializing ? 'Инициализация жүрүүдө...' : 'Бардык категорияларды кошуу'),
    );
  }
Widget _buildCategoryTile(ProductCategoryModel category) {
    return ExpansionTile(
      leading: _buildCategoryImage(category.image),
      title: Text(category.name),
      subtitle: Text('Category Type: ${category.categoryType}, Product Type: ${category.productType ?? "Not set"}'),
      children: [
        if (category.subcategoryIds.isNotEmpty)
          FutureBuilder<List<ProductCategoryModel>>(
            future: _loadSubcategories(category.subcategoryIds),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Ката: ${snapshot.error}'),
                );
              } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: _buildCategoryList(snapshot.data!),
                );
              }
              return const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Субкатегориялар жок'),
              );
            },
          ),
      ],
    );
  }
  Future<List<ProductCategoryModel>> _loadSubcategories(List<String> subcategoryIds) async {
    final categoryBloc = context.read<CategoryBloc>();
    final subcategories = <ProductCategoryModel>[];
    for (final id in subcategoryIds) {
      categoryBloc.add(GetCategory(categoryId: id));
      await for (final state in categoryBloc.stream) {
        if (state is CategoryLoaded) {
          subcategories.add(state.category);
          break;
        } else if (state is CategoryError) {
          break;
        }
      }
    }
    return subcategories;
  }

  Widget _buildCategoryImage(String? imagePath) {
    if (imagePath == null) return const Icon(Icons.category);
    return CachedNetworkImage(
      imageUrl: imagePath,
      width: 50,
      height: 50,
      fit: BoxFit.cover,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
  Future<void> _initializeCategories(BuildContext context) async {
    if (_isInitializing) return;
    setState(() {
      _isInitializing = true;
    });
    try {
      final updatedCategories = await _uploadImagesToFirebase();
      await _initializeCategoriesInFirestore(context, updatedCategories);
      setState(() {
        _isInitialized = true;
        _isInitializing = false;
      });
      _showSnackBar(context, 'Категориялар ийгиликтүү инициализацияланды');
    } catch (e) {
      setState(() {
        _isInitializing = false;
      });
      _showSnackBar(context, 'Категорияларды инициализациялоодо ката кетти: $e');
    }
  }
  Future<List<Map<String, dynamic>>> _uploadImagesToFirebase() async {
    try {
      final updatedCategories = <Map<String, dynamic>>[];
      for (var category in _initialCategories) {
        try {
          final updatedCategory = await _uploadCategoryRecursively(category);
          updatedCategories.add(updatedCategory);
        } catch (e) {
          print('Error uploading category: ${category['name']}, Error: $e');
        }
      }
      return updatedCategories;
    } catch (e) {
      return _initialCategories;
    }
  }

  Future<Map<String, dynamic>> _uploadCategoryRecursively(Map<String, dynamic> category) async {
    final updatedCategory = Map<String, dynamic>.from(category);
    if (category['image'] != null) {
      try {
        final imageUrl = await _uploadCategoryImage(category['image']);
        updatedCategory['image'] = imageUrl;
      } catch (e) {
        updatedCategory['image'] = null;
      }
    }

    if (category['subcategories'] != null) {
      final updatedSubcategories = <Map<String, dynamic>>[];
      for (var subcategory in category['subcategories']) {
        try {
          final updatedSubcategory = await _uploadCategoryRecursively(subcategory);
          updatedSubcategories.add(updatedSubcategory);
        } catch (e) {
          print('Error processing subcategory: ${subcategory['name']}, Error: $e');
        }
      }
      updatedCategory['subcategories'] = updatedSubcategories;
    }

    return updatedCategory;
  }
  Future<String?> _uploadCategoryImage(String assetName) async {
    try {
      final byteData = await rootBundle.load('assets/images/categories/$assetName');
      final file = await File('${(await getTemporaryDirectory()).path}/$assetName').create();
      await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      final ref = _storage.ref('categories/$assetName');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

Future<void> _initializeCategoriesInFirestore(BuildContext context, List<Map<String, dynamic>> categories) async {
    final categoryBloc = context.read<CategoryBloc>();
    try {
      categoryBloc.add(InitializeCategories(categories));
    } catch (e) {
      throw Exception('Категорияларды Firestore\'го жүктөөдө ката кетти: $e');
    }
  }
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    ));
  }
}