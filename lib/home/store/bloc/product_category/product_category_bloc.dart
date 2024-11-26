import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/home/store/bloc/product_category/product_category_event.dart';
import 'package:my_example_file/home/store/bloc/product_category/product_category_state.dart';
import 'package:my_example_file/home/store/repositories/category_repository.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository;

  CategoryBloc({required CategoryRepository categoryRepository})
      : _categoryRepository = categoryRepository,
        super(CategoryInitial()) {
    on<GetCategories>(_onGetCategories);
    on<GetCategory>(_onGetCategory);
    on<InitializeCategories>(_onInitializeCategories);
    on<AddProductToCategory>(_onAddProductToCategory);
  }



  Future<void> _onGetCategories(GetCategories event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      final categories = await _categoryRepository.getCategories(
        parentCategoryId: event.parentCategoryId,
        categoryType: event.categoryType,
        depth: event.depth,
      );
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(CategoryError('Категорияларды алууда ката кетти: $e'));
    }
  }

  Future<void> _onGetCategory(GetCategory event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      final category = await _categoryRepository.getById(event.categoryId);
      if (category != null) {
        emit(CategoryLoaded(category));
      } else {
        emit(CategoryError('Категория табылган жок'));
      }
    } catch (e) {
      emit(CategoryError('Категорияны алууда ката кетти: $e'));
    }
  }

  Future<void> _onInitializeCategories(InitializeCategories event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      await _categoryRepository.initializeCategories(event.initialCategories);
      emit( CategoryOperationSuccess('Категориялар ийгиликтүү инициализацияланды'));
    } catch (e) {
      emit(CategoryError('Категорияларды инициализациялоодо ката кетти: $e'));
    }
  }
  Future<void> _onAddProductToCategory(AddProductToCategory event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      await _categoryRepository.addProductToCategory(event.categoryId, event.productId);
      emit( CategoryOperationSuccess('Продукт категорияга кошулду'));
    } catch (e) {
      emit(CategoryError('Продуктту категорияга кошууда ката кетти: $e'));
    }
  }
}

