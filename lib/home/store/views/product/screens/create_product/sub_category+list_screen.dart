import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/home/store/bloc/product_category/product_category_bloc.dart';
import 'package:my_example_file/home/store/bloc/product_category/product_category_event.dart';
import 'package:my_example_file/home/store/bloc/product_category/product_category_state.dart';
import 'package:my_example_file/home/store/views/product/screens/create_product/create_photo_screen.dart';
import 'package:my_example_file/home/store/models/product_category.dart';

class SubcategoryListScreen extends StatefulWidget {
  final String parentCategoryId;
  final String storeId;

  const SubcategoryListScreen({
    Key? key,
    required this.parentCategoryId,
    required this.storeId,
  }) : super(key: key);

  @override
  _SubcategoryListScreenState createState() => _SubcategoryListScreenState();
}

class _SubcategoryListScreenState extends State<SubcategoryListScreen> {
  @override
  void initState() {
    super.initState();
    _loadSubcategories();
  }

  void _loadSubcategories() {
    context.read<CategoryBloc>().add(GetCategories(parentCategoryId: widget.parentCategoryId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Субкатегориялар'),
      ),
      body: BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state is CategoryError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Ката: ${state.message}')),
            );
          }
        },
        builder: (context, state) {
          if (state is CategoryLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CategoriesLoaded) {
            return _buildCategoryList(context, state.categories);
          } else if (state is CategoryError) {
            return _buildErrorWidget(context, state.message);
          } else {
            return _buildEmptyWidget(context);
          }
        },
      ),
    );
  }

  Widget _buildCategoryList(BuildContext context, List<ProductCategoryModel> categories) {
    if (categories.isEmpty) {
      return _buildEmptyWidget(context);
    }

    return RefreshIndicator(
      onRefresh: () async {
        _loadSubcategories();
      },
      child: ListView.separated(
        itemCount: categories.length,
        separatorBuilder: (context, index) => Divider(),
        itemBuilder: (context, index) {
          final subcategory = categories[index];
          return ListTile(
            title: Text(subcategory.name),
            subtitle: Text(subcategory.categoryType),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => _onCategoryTap(context, subcategory),
          );
        },
      ),
    );
  }

  Widget _buildEmptyWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Субкатегориялар табылган жок'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadSubcategories,
            child: Text('Жаңыртуу'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Ката: $message'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadSubcategories,
            child: Text('Кайра аракет кылуу'),
          ),
        ],
      ),
    );
  }

  void _onCategoryTap(BuildContext context, ProductCategoryModel subcategory) {
    if (subcategory.subcategoryIds.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SubcategoryListScreen(
            parentCategoryId: subcategory.id,
            storeId: widget.storeId,
          ),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CreateProductPhotoScreen(
            categoryId: subcategory.id,
            storeId: widget.storeId,
          ),
        ),
      );
    }
  }
}