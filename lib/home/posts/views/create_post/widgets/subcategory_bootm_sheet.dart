import 'package:flutter/material.dart';
import 'package:my_example_file/home/posts/models/category_model.dart';

class SubcategoryBottomSheet extends StatelessWidget {
  final String categoryName;
  final List<SubCategoryModel> subcategories;
  final List<SubCategoryModel> selectedSubcategories;
  final ValueChanged<SubCategoryModel> onSubcategorySelected;

  const SubcategoryBottomSheet({
    Key? key,
    required this.categoryName,
    required this.subcategories,
    required this.selectedSubcategories,
    required this.onSubcategorySelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.2,
      maxChildSize: 0.95,
      builder: (_, controller) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).canvasColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              AppBar(
                title: Text('Подкатегория тандоо: $categoryName'),
                backgroundColor: Colors.transparent,
                elevation: 0,
                actions: [
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: subcategories.length,
                  itemBuilder: (context, index) {
                    final subcategory = subcategories[index];
                    final isSelected = selectedSubcategories.contains(subcategory);
                    return ListTile(
                      title: Text(
                        subcategory.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check, color: Colors.green)
                          : null,
                      onTap: () {
                        onSubcategorySelected(subcategory);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}