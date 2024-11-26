import 'package:my_example_file/home/store/models/product_category.dart';

abstract class CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryCreated extends CategoryState {
  final ProductCategoryModel category;

  CategoryCreated(this.category);
}

class CategoriesLoaded extends CategoryState {
  final List<ProductCategoryModel> categories;

  CategoriesLoaded(this.categories);
}

class CategoryLoaded extends CategoryState {
  final ProductCategoryModel category;

  CategoryLoaded(this.category);
}

class CategoryOperationSuccess extends CategoryState {
  final String message;

   CategoryOperationSuccess(this.message);
}

class CategoryError extends CategoryState {
  final String message;

  CategoryError(this.message);
}