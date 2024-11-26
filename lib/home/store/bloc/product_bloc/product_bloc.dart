import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/home/store/bloc/product_bloc/product_event.dart';
import 'package:my_example_file/home/store/bloc/product_bloc/product_state.dart';
import 'package:my_example_file/home/store/repositories/product_services.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductService _productService;
  String? _currentCategoryId;

  ProductBloc({
    required ProductService productService,
  })  : _productService = productService,
        super(ProductInitial()) {
    on<CreateProduct>(_onCreateProduct);
    on<GetAllProducts>(_onGetAllProducts);
    on<GetProductsByCategory>(_onGetProductsByCategory);
    on<LoadMoreProducts>(_onLoadMoreProducts);
    on<GetNewProducts>(_onGetNewProducts);
    on<GetCheapProducts>(_onGetCheapProducts);
    on<GetPopularProducts>(_onGetPopularProducts);
  }

  Future<void> _onCreateProduct(
      CreateProduct event, Emitter<ProductState> emit) async {
    emit(const ProductLoading());
    try {
      final product = await _productService.createProduct(event.product);
      emit(ProductLoaded(product));
    } catch (e) {
      emit(ProductError('Продукт түзүүдө ката кетти: $e'));
    }
  }


  Future<void> _onGetAllProducts(
      GetAllProducts event, Emitter<ProductState> emit) async {
    emit(const ProductLoading(isFirstFetch: true));
    await _loadProducts(null, emit);
  }

  Future<void> _onGetProductsByCategory(
      GetProductsByCategory event, Emitter<ProductState> emit) async {
    if (_currentCategoryId != event.categoryId) {
      _currentCategoryId = event.categoryId;
      emit(const ProductLoading(isFirstFetch: true));
    }
    await _loadProductsByCategory(event.categoryId, emit);
  }

  Future<void> _onLoadMoreProducts(
      LoadMoreProducts event, Emitter<ProductState> emit) async {
    await _loadMoreProducts(_currentCategoryId, emit);
  }

  Future<void> _onGetNewProducts(
      GetNewProducts event, Emitter<ProductState> emit) async {
    emit(const ProductLoading(isFirstFetch: true));
    try {
      final products = await _productService.getNewProducts();
      emit(ProductsLoaded(products, hasReachedMax: true));
    } catch (e) {
      emit(ProductError('Жаңы продуктуларды жүктөөдө ката кетти: $e'));
    }
  }

  Future<void> _onGetCheapProducts(
      GetCheapProducts event, Emitter<ProductState> emit) async {
    emit(const ProductLoading(isFirstFetch: true));
    try {
      final products = await _productService.getPopularProducts();
      emit(ProductsLoaded(products.take(10).toList(), hasReachedMax: true));
    } catch (e) {
      emit(ProductError('Арзан продуктуларды жүктөөдө ката кетти: $e'));
    }
  }

  Future<void> _onGetPopularProducts(
      GetPopularProducts event, Emitter<ProductState> emit) async {
    emit(const ProductLoading(isFirstFetch: true));
    try {
      final products = await _productService.getPopularProducts();
      emit(ProductsLoaded(products, hasReachedMax: true));
    } catch (e) {
      emit(ProductError('Популярдуу продуктуларды жүктөөдө ката кетти: $e'));
    }
  }

  Future<void> _loadProducts(
      String? categoryId, Emitter<ProductState> emit) async {
    try {
      final products = await _productService.getPopularProducts();
      emit(ProductsLoaded(products,
          categoryIds: categoryId != null ? [categoryId] : []));
    } catch (e) {
      emit(ProductError('Продуктуларды жүктөөдө ката кетти: $e'));
    }
  }

  Future<void> _loadProductsByCategory(
      String categoryId, Emitter<ProductState> emit) async {
    try {
      final products =
          await _productService.getProductsByCategory(categoryId);
      emit(ProductsLoaded(products, categoryIds: [categoryId]));
    } catch (e) {
      emit(ProductError(
          'Категория боюнча продуктуларды жүктөөдө ката кетти: $e'));
    }
  }

  Future<void> _loadMoreProducts(
      String? categoryId, Emitter<ProductState> emit) async {
    final currentState = state;
    if (currentState is ProductsLoaded && !currentState.hasReachedMax) {
      try {
        final moreProducts = categoryId != null
            ? await _productService.getProductsByCategory(categoryId,
                )
            : await _productService.getPopularProducts(
              );

        if (moreProducts.isEmpty) {
          emit(currentState.copyWith(hasReachedMax: true));
        } else {
          emit(currentState.copyWith(
            products: List.of(currentState.products)..addAll(moreProducts),
          ));
        }
      } catch (e) {
        emit(ProductError('Кошумча продуктуларды жүктөөдө ката кетти: $e'));
      }
    }
  }
}
