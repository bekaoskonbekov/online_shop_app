import 'package:flutter/material.dart';
import 'package:my_example_file/home/posts/views/create_post/widgets/category_bottom_sheet.dart';
import 'package:my_example_file/home/posts/models/category_model.dart';

class CategorySelector extends StatelessWidget {
  final List<CategoryModel> selectedCategories;
  final ValueChanged<CategoryModel> onCategorySelected;
  final List<CategoryModel> categories; // Жаңы кошулган параметр

  const CategorySelector({
    Key? key,
    required this.selectedCategories,
    required this.onCategorySelected,
    required this.categories, // Жаңы кошулган параметр
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 26, 26, 27),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        title: Text(
          selectedCategories.isEmpty
              ? 'Категория тандоо'
              : selectedCategories.map((c) => c.name).join(', '),
          style: const TextStyle(color: Colors.white),
        ),
        trailing: const Icon(Icons.arrow_drop_down, color: Colors.white),
        onTap: () => _showCategoryBottomSheet(context),
      ),
    );
  }

  void _showCategoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return CategoryBottomSheet(
          selectedCategories: selectedCategories,
          onCategorySelected: onCategorySelected,
          categories: categories, // Жаңы кошулган параметр колдонулду
        );
      },
    );
  }
}