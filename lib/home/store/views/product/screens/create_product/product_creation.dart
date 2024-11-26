import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/home/store/models/brand_model.dart';
import 'package:my_example_file/home/store/models/color_model.dart';
import 'package:my_example_file/home/store/models/country_of_origin_model.dart';
import 'package:my_example_file/home/store/models/product/product_model.dart';
import 'package:my_example_file/home/store/models/product/product_params.dart';
import 'package:my_example_file/home/store/repositories/brand_repository.dart';
import 'package:my_example_file/home/store/repositories/product_repository.dart';
import '../../../../models/material_model.dart';
import '../../../../models/product_category.dart';
import '../../../../repositories/color_repository.dart';
import '../../../../repositories/country_of_origin_repository.dart';
import '../../../../repositories/material_repository.dart';
import '../../../../repositories/category_repository.dart';
abstract class ProductCreationEvent extends Equatable {
  const ProductCreationEvent();
  @override
  List<Object> get props => [];
}
class InitializeProductCreation extends ProductCreationEvent {
  final String categoryId;
  final String storeId;
  const InitializeProductCreation(
      {required this.categoryId, required this.storeId});
  @override
  List<Object> get props => [categoryId, storeId];
}
class UpdateProductField extends ProductCreationEvent {
  final String field;
  final dynamic value;
  const UpdateProductField({required this.field, required this.value});
  @override
  List<Object> get props => [field, value];
}
class SubmitProductCreation extends ProductCreationEvent {
  final ProductParams productFields;
  const SubmitProductCreation({required this.productFields});
  @override
  List<Object> get props => [productFields];
}
abstract class ProductCreationState extends Equatable {
  const ProductCreationState();
  @override
  List<Object> get props => [];
}
class ProductCreationInitial extends ProductCreationState {}
class ProductCreationLoading extends ProductCreationState {}
class ProductCreationReady extends ProductCreationState {
  final List<BrandModel> availableBrands;
  final List<MaterialModel> availableMaterials;
  final List<ColorModel> availableColors;
  final List<CountryOfOriginModel> availableCountries;
  final Map<String, dynamic> productData;
  final ProductCategoryModel category;
  final BrandModel? selectedBrand;
  final MaterialModel? selectedMaterial;
  final ColorModel? selectedColor;
  final CountryOfOriginModel? selectedCountry;

  const ProductCreationReady({
    required this.availableBrands,
    required this.availableMaterials,
    required this.availableColors,
    required this.availableCountries,
    required this.category,
    this.productData = const {},
    this.selectedBrand,
    this.selectedMaterial,
    this.selectedColor,
    this.selectedCountry,
  });

  ProductCreationReady copyWith({
    List<BrandModel>? availableBrands,
    List<MaterialModel>? availableMaterials,
    List<ColorModel>? availableColors,
    List<CountryOfOriginModel>? availableCountries,
    Map<String, dynamic>? productData,
    ProductCategoryModel? category,
    BrandModel? selectedBrand,
    MaterialModel? selectedMaterial,
    ColorModel? selectedColor,
    CountryOfOriginModel? selectedCountry,
  }) {
    return ProductCreationReady(
      availableBrands: availableBrands ?? this.availableBrands,
      availableMaterials: availableMaterials ?? this.availableMaterials,
      availableColors: availableColors ?? this.availableColors,
      availableCountries: availableCountries ?? this.availableCountries,
      productData: productData ?? this.productData,
      category: category ?? this.category,
      selectedBrand: selectedBrand ?? this.selectedBrand,
      selectedMaterial: selectedMaterial ?? this.selectedMaterial,
      selectedColor: selectedColor ?? this.selectedColor,
      selectedCountry: selectedCountry ?? this.selectedCountry,
    );
  }
   @override
  List<Object> get props => [
    availableBrands,
    availableMaterials,
    availableColors,
    availableCountries,
    productData,
    category,
    if (selectedBrand != null) selectedBrand!,
    if (selectedMaterial != null) selectedMaterial!,
    if (selectedColor != null) selectedColor!,
    if (selectedCountry != null) selectedCountry!,
  ];
}
class ProductCreationSuccess extends ProductCreationState {
  final ProductParams productFields;
  const ProductCreationSuccess({required this.productFields});
  @override
  List<Object> get props => [productFields];
}
class ProductCreationError extends ProductCreationState {
  final String message;
  const ProductCreationError({required this.message});
  @override
  List<Object> get props => [message];
}
class ProductCreationBloc
    extends Bloc<ProductCreationEvent, ProductCreationState> {
  final ProductRepository _productRepository;
  final BrandRepository _brandRepository;
  final MaterialRepository _materialRepository;
  final CountryOfOriginRepository _countryOfOriginRepository;
  final ColorRepository _colorRepository;
  final CategoryRepository _categoryRepository;
  ProductCreationBloc({
    required ProductRepository productRepository,
    required BrandRepository brandRepository,
    required MaterialRepository materialRepository,
    required CountryOfOriginRepository countryOfOriginRepository,
    required ColorRepository colorRepository,
    required CategoryRepository categoryRepository,
  })  : _productRepository = productRepository,
        _brandRepository = brandRepository,
        _materialRepository = materialRepository,
        _countryOfOriginRepository = countryOfOriginRepository,
        _colorRepository = colorRepository,
        _categoryRepository = categoryRepository,
        super(ProductCreationInitial()) {
    on<InitializeProductCreation>(_onInitializeProductCreation);
    on<UpdateProductField>(_onUpdateProductField);
    on<SubmitProductCreation>(_onSubmitProductCreation);
  }

   Future<void> _onInitializeProductCreation(
    InitializeProductCreation event,
    Emitter<ProductCreationState> emit,
  ) async {
    emit(ProductCreationLoading());
    try {
      final category = await _categoryRepository.getById(event.categoryId);
      if (category == null) {
        throw Exception('Category not found');
      }

      final results = await Future.wait([
        _brandRepository.getBrandsByCategory(category.categoryType),
        _materialRepository.getMaterialsByCategory(category.categoryType),
        _colorRepository.getAllColors(),
        _countryOfOriginRepository.getAllCountries(),
      ]);

      final brands = results[0] as List<BrandModel>;
      final materials = results[1] as List<MaterialModel>;
      final colors = results[2] as List<ColorModel>;
      final countries = results[3] as List<CountryOfOriginModel>;

      emit(ProductCreationReady(
        availableBrands: brands,
        availableMaterials: materials,
        availableColors: colors,
        availableCountries: countries,
        category: category,
        productData: {
          'categoryId': event.categoryId,
          'storeId': event.storeId,
        },
        selectedBrand: brands.isNotEmpty ? brands.first : null,
        selectedMaterial: materials.isNotEmpty ? materials.first : null,
        selectedColor: colors.isNotEmpty ? colors.first : null,
        selectedCountry: countries.isNotEmpty ? countries.first : null,
      ));
    } catch (e) {
      emit(ProductCreationError(message: 'Маалыматтарды жүктөөдө ката кетти: $e'));
    }
  }


  void _onUpdateProductField(
    UpdateProductField event,
    Emitter<ProductCreationState> emit,
  ) {
    if (state is ProductCreationReady) {
      final currentState = state as ProductCreationReady;
      final updatedProductData =
          Map<String, dynamic>.from(currentState.productData)
            ..[event.field] = event.value;

      dynamic selectedItem;
      switch (event.field) {
        case 'brandId':
          selectedItem = currentState.availableBrands
              .firstWhere((brand) => brand.brandId == event.value);
          break;
        case 'materialId':
          selectedItem = currentState.availableMaterials
              .firstWhere((material) => material.materialId == event.value);
          break;
        case 'colorId':
          selectedItem = currentState.availableColors
              .firstWhere((color) => color.colorId == event.value);
          break;
        case 'countryId':
          selectedItem = currentState.availableCountries
              .firstWhere((country) => country.countryId == event.value);
          break;
      }

      emit(currentState.copyWith(
        productData: updatedProductData,
        selectedBrand: event.field == 'brandId'
            ? selectedItem
            : currentState.selectedBrand,
        selectedMaterial: event.field == 'materialId'
            ? selectedItem
            : currentState.selectedMaterial,
        selectedColor: event.field == 'colorId'
            ? selectedItem
            : currentState.selectedColor,
        selectedCountry: event.field == 'countryId'
            ? selectedItem
            : currentState.selectedCountry,
      ));
    }
  }

  Future<void> _onSubmitProductCreation(
    SubmitProductCreation event,
    Emitter<ProductCreationState> emit,
  ) async {
    emit(ProductCreationLoading());
    try {
      final ProductModel product = await _productRepository.create(
        ProductModel(params: event.productFields),
      );
      emit(ProductCreationSuccess(productFields: product.params));
    } catch (e) {
      emit(ProductCreationError(message: 'Продукт түзүүдө ката кетти: $e'));
    }
  }
}
