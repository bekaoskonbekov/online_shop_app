// Events
abstract class CategoryEvent {}

class CreateCategory extends CategoryEvent {
  final String name;
  final String parentCategoryId;
  final String categoryType;
  final String? productType;
  final String? image;

  CreateCategory({
    required this.name,
    required this.parentCategoryId,
    required this.categoryType,
    this.productType,
    this.image,
  });
}

class GetCategories extends CategoryEvent {
  final String parentCategoryId;
  final String? categoryType;
  final int depth;

  GetCategories({
    this.parentCategoryId = '',
    this.categoryType,
    this.depth = 1,
  });
}

class GetCategory extends CategoryEvent {
  final String categoryId;
  final int depth;

  GetCategory({required this.categoryId, this.depth = 0});
}

class InitializeCategories extends CategoryEvent {
  final List<Map<String, dynamic>> initialCategories;

  InitializeCategories(this.initialCategories);
}

class SearchCategories extends CategoryEvent {
  final String query;
  final int limit;

  SearchCategories(this.query, {this.limit = 10});
}

class AddProductToCategory extends CategoryEvent {
  final String categoryId;
  final String productId;

  AddProductToCategory({required this.categoryId, required this.productId});
}

class RemoveProductFromCategory extends CategoryEvent {
  final String categoryId;
  final String productId;

  RemoveProductFromCategory({required this.categoryId, required this.productId});
}

class ClearAllCategories extends CategoryEvent {}

// States
