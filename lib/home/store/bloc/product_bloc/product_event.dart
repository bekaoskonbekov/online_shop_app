import 'package:equatable/equatable.dart';
import 'package:my_example_file/home/store/models/product/product_model.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}
class GetCheapProducts extends ProductEvent {

  const GetCheapProducts();

  @override
  List<Object> get props => [];
}
class GetPopularProducts extends ProductEvent {

  const GetPopularProducts();

  @override
  List<Object> get props => [];
}
class GetNewProducts extends ProductEvent {
  const GetNewProducts();
}
class CreateProduct extends ProductEvent {
  final ProductModel product;

  const CreateProduct({required this.product});

  @override
  List<Object> get props => [product];
}

class GetProduct extends ProductEvent {
  final String productId;

  const GetProduct({required this.productId});

  @override
  List<Object> get props => [productId];
}

class GetProductsByCategory extends ProductEvent {
  final String categoryId;
  final String? sortBy;

  const GetProductsByCategory(this.categoryId, {this.sortBy,});

  @override
  List<Object> get props => [categoryId, if (sortBy != null) sortBy!];
}

class GetAllProducts extends ProductEvent {
  final String? sortBy;

  const GetAllProducts({this.sortBy});

  @override
  List<Object> get props => [ if (sortBy != null) sortBy!];
}

class LoadMoreProducts extends ProductEvent {}
