import 'package:flutter/material.dart';
import 'package:my_example_file/home/posts/views/create_post/widgets/subcategory_bootm_sheet.dart';
import 'package:my_example_file/home/posts/models/category_model.dart';

class SubcategorySelector extends StatelessWidget {
  final List<SubCategoryModel> selectedSubcategories;
  final ValueChanged<SubCategoryModel> onSubcategorySelected;
  final List<CategoryModel> selectedCategories;

  const SubcategorySelector({
    Key? key,
    required this.selectedSubcategories,
    required this.onSubcategorySelected,
    required this.selectedCategories,
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
          selectedSubcategories.isEmpty
              ? 'Подкатегория тандоо'
              : selectedSubcategories.map((s) => s.name).join(', '),
          style: const TextStyle(color: Colors.white),
        ),
        trailing: const Icon(Icons.arrow_drop_down, color: Colors.white),
        onTap: () {
          if (selectedCategories.isNotEmpty) {
            _showSubCategoryBottomSheet(context, selectedCategories.first);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Алгач категория тандаңыз')),
            );
          }
        },
      ),
    );
  }

  void _showSubCategoryBottomSheet(BuildContext context, CategoryModel category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SubcategoryBottomSheet(
          categoryName: category.name,
          subcategories: category.subcategories,
          selectedSubcategories: selectedSubcategories,
          onSubcategorySelected: onSubcategorySelected,
        );
      },
    );
  }
}