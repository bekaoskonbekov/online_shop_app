import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/home/store/bloc/product_category/product_category_bloc.dart';
import 'package:my_example_file/home/store/bloc/product_category/product_category_event.dart';
import 'package:my_example_file/home/store/bloc/product_category/product_category_state.dart';
import 'package:my_example_file/home/store/models/product_category.dart';

class CategoryListView extends StatelessWidget {
  final List<String> categoryPath;
  final Function(ProductCategoryModel) onCategorySelected;

  const CategoryListView({
    Key? key,
    required this.categoryPath,
    required this.onCategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoryBloc, CategoryState>(
      builder: (context, state) {
        if (state is CategoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is CategoriesLoaded) {
          return _buildCategoryList(context, state.categories);
        } else if (state is CategoryError) {
          return Center(child: Text(state.message));
        }
        // If the state is not handled, trigger a reload
        WidgetsBinding.instance.addPostFrameCallback((_) {
          context.read<CategoryBloc>().add( GetCategories(parentCategoryId: '', depth: 1));
        });
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCategoryList(BuildContext context, List<ProductCategoryModel> categories) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        itemBuilder: (context, index) => _buildCategoryItem(context, categories[index]),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, ProductCategoryModel category) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: () => onCategorySelected(category),
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.grey[300],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              _buildCategoryImage(category),
              _buildGradientOverlay(),
              _buildCategoryName(category),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryImage(ProductCategoryModel category) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: category.image != null && category.image!.isNotEmpty
          ? CachedNetworkImage(
              imageUrl: category.image!,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) {
                print('Error loading image: $error');
                return const Icon(Icons.error, size: 50, color: Colors.red);
              },
            )
          : const Icon(Icons.category, size: 50, color: Colors.grey),
    );
  }

  Widget _buildGradientOverlay() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryName(ProductCategoryModel category) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          category.name,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}