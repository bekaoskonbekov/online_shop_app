import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/home/store/bloc/product_category/product_category_bloc.dart';
import 'package:my_example_file/home/store/bloc/product_category/product_category_event.dart';
import 'package:my_example_file/home/store/bloc/product_category/product_category_state.dart';
import 'package:my_example_file/home/store/views/product/screens/create_product/sub_category+list_screen.dart';

class CategoryListScreen extends StatelessWidget {
  final String storeId;
  const CategoryListScreen({super.key, required this.storeId});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Категориялар'),
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryInitial) {
            context.read<CategoryBloc>().add(GetCategories(parentCategoryId: ''));
            return Center(child: CircularProgressIndicator());
          } else if (state is CategoryLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CategoriesLoaded) {
            if (state.categories.isEmpty) {
              return Center(child: Text('Категориялар жок'));
            }
            return ListView.builder(
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return ListTile(
                  title: Text(category.name),
                  leading: category.image != null
                      ? CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(category.image!),
                        )
                      : Icon(Icons.category),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BlocProvider.value(
                          value: BlocProvider.of<CategoryBloc>(context),
                          child: SubcategoryListScreen(
                            parentCategoryId: category.id,
                            storeId: storeId,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            );
          } else if (state is CategoryError) {
            return Center(child: Text('Ката: ${state.message}'));
          } else {
            return Center(child: Text('Белгисиз абал'));
          }
        },
      ),
    );
  }
}