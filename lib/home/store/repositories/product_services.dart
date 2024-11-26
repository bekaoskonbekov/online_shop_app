// product_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_example_file/home/store/models/product/product_model.dart';
import 'package:my_example_file/home/store/product/clothing/models/clothing_model.dart';
import 'package:my_example_file/home/store/product/electronics/models/electronic_model.dart';
import 'package:my_example_file/home/store/product/electronics/models/OS_model.dart';
import 'package:my_example_file/home/store/repositories/product_repository.dart';
import 'package:my_example_file/home/store/product/clothing/repositories/clothing_repository.dart';
import 'package:my_example_file/home/store/product/electronics/repositories/electronic_repository.dart';
import 'package:my_example_file/home/store/product/electronics/repositories/OS_repository.dart';
import 'package:my_example_file/home/store/repositories/material_repository.dart';
import 'package:my_example_file/home/store/repositories/color_repository.dart';
import 'package:my_example_file/home/store/repositories/brand_repository.dart';
import 'package:my_example_file/home/store/repositories/country_of_origin_repository.dart';
import 'package:my_example_file/home/store/models/brand_model.dart';
import 'package:my_example_file/home/store/models/color_model.dart';
import 'package:my_example_file/home/store/models/country_of_origin_model.dart';
import 'package:my_example_file/home/store/models/material_model.dart';

class ProductService {
  final ProductRepository _productRepository;
  final ElectronicsRepository _electronicsRepository;
  final OSRepository _osRepository;
  final ClothingRepository _clothingRepository;
  final MaterialRepository _materialRepository;
  final ColorRepository _colorRepository;
  final BrandRepository _brandRepository;
  final CountryOfOriginRepository _countryOfOriginRepository;

  ProductService(FirebaseFirestore firestore)
      : _productRepository = ProductRepository(firestore),
        _electronicsRepository = ElectronicsRepository(firestore),
        _osRepository = OSRepository(firestore),
        _clothingRepository = ClothingRepository(),
        _materialRepository = MaterialRepository(),
        _colorRepository = ColorRepository(),
        _brandRepository = BrandRepository(),
        _countryOfOriginRepository = CountryOfOriginRepository();

  // Product methods
  Future<ProductModel> createProduct(ProductModel product) async {
    if (product is ClothingModel) {
      return _clothingRepository.create(product);
    } else if (product is ElectronicsModel) {
      return _electronicsRepository.createElectronics(product);
    } else {
      return _productRepository.create(product);
    }
  }

  Future<ProductModel?> getProductById(String id) {
    return _productRepository.getById(id);
  }

  Future<List<ProductModel>> getProductsByCategory(String categoryId) {
    return _productRepository.getProductsByCategory(categoryId);
  }

  Future<List<ProductModel>> getNewProducts({int limit = 10}) {
    return _productRepository.getNewProducts(limit: limit);
  }

  Future<List<ProductModel>> getPopularProducts({int limit = 10}) {
    return _productRepository.getPopularProducts(limit: limit);
  }

  Future<void> updateProduct(ProductModel product) {
    return _productRepository.update(product);
  }

  Future<void> deleteProduct(String productId) {
    return _productRepository.delete(productId);
  }

  // Electronics methods
  Future<List<ElectronicsModel>> getElectronicsByType(String type) {
    return _electronicsRepository.getElectronicsByType(type);
  }

  Future<ElectronicsModel?> getElectronicsById(String id) {
    return _electronicsRepository.getElectronicsById(id);
  }

  // OS methods
  Future<Map<String, List<OperatingSystemModel>>>
      getAllOSGroupedByProductType() {
    return _osRepository.getAllGroupedByProductType();
  }

  Future<void> addProductToOS(String productId, String osId) async {
    return _osRepository.addProductToOS(productId, osId);
  }

  Future<void> initializeOS(Map<String, List<Map<String, dynamic>>> osList) {
    return _osRepository.initializeOS(osList);
  }

  // Clothing methods
  Future<List<ClothingModel>> getAllClothings() {
    return _clothingRepository.getAllClothings();
  }

  // Material methods
  Future<void> initializeMaterials(
      Map<String, List<String>> materialsByCategory) {
    return _materialRepository.initializeMaterials(materialsByCategory);
  }

  Future<List<MaterialModel>> getAllMaterials() {
    return _materialRepository.getAllMaterials();
  }

  Future<MaterialModel?> getMaterialById(String materialId) {
    return _materialRepository.getMaterialById(materialId);
  }

  Future<List<MaterialModel>> getMaterialsByCategory(String categoryType) {
    return _materialRepository.getMaterialsByCategory(categoryType);
  }

  // Color methods
  Future<void> initializeColors(List<Map<String, dynamic>> colors) {
    return _colorRepository.initializeColors(colors);
  }

  Future<List<ColorModel>> getAllColors() {
    return _colorRepository.getAllColors();
  }

 

  // Brand methods
  Future<void> initializeBrands(Map<String, List<String>> brandsByCategory) {
    return _brandRepository.initializeBrands(brandsByCategory);
  }

  Future<List<BrandModel>> getBrandsByCategory(String categoryType) {
    return _brandRepository.getBrandsByCategory(categoryType);
  }

  Future<void> addProductToBrand(String productId, String brandId) {
    return _brandRepository.addProductToBrand(productId, brandId);
  }

  Future<void> addProductNoBrand(String productId) async {
    return await _brandRepository.addProductNoBrand(productId);
  }

  // Country of Origin methods
  Future<void> initializeCountries(List<Map<String, dynamic>> countries) {
    return _countryOfOriginRepository.initializeCountries(countries);
  }

  Future<List<CountryOfOriginModel>> getAllCountries() {
    return _countryOfOriginRepository.getAllCountries();
  }

  Future<CountryOfOriginModel?> getCountryById(String countryId) {
    return _countryOfOriginRepository.getCountryById(countryId);
  }
}
