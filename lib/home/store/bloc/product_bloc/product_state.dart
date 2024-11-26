import 'package:equatable/equatable.dart';
import 'package:my_example_file/home/store/models/product/product_model.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {
  final bool isFirstFetch;
  
  const ProductLoading({this.isFirstFetch = false});

  @override
  List<Object> get props => [isFirstFetch];
}

class ProductsLoaded extends ProductState {
  final List<ProductModel> products;
  final List<String> categoryIds;
  final bool isLoading;
  final bool hasReachedMax;
  final bool isParentCategory;

  const ProductsLoaded(
    this.products, 
    {
      this.categoryIds = const [],
      this.isLoading = false, 
      this.hasReachedMax = false,
      this.isParentCategory = false
    }
  );

  @override
  List<Object> get props => [products, categoryIds, isLoading, hasReachedMax, isParentCategory];

  ProductsLoaded copyWith({
    List<ProductModel>? products,
    List<String>? categoryIds,
    bool? isLoading,
    bool? hasReachedMax,
    bool? isParentCategory,
  }) {
    return ProductsLoaded(
      products ?? this.products,
      categoryIds: categoryIds ?? this.categoryIds,
      isLoading: isLoading ?? this.isLoading,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isParentCategory: isParentCategory ?? this.isParentCategory,
    );
  }
}

class ProductLoaded extends ProductState {
  final ProductModel product;

  const ProductLoaded(this.product);

  @override
  List<Object> get props => [product];
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List<Object> get props => [message];
}