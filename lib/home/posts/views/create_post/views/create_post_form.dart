import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/blocs/post/post_bloc.dart';
import 'package:my_example_file/blocs/post/post_event.dart';
import 'package:my_example_file/blocs/post/post_state.dart';
import 'package:my_example_file/core/helpers/firebase_storage_helper.dart';
import 'package:my_example_file/core/utils/category.dart';
import 'package:my_example_file/core/utils/region.dart';
import 'package:my_example_file/core/views/main_screen.dart';
import 'package:my_example_file/home/posts/views/create_post/widgets/category_selector.dart';
import 'package:my_example_file/home/posts/views/create_post/widgets/custom_dropdown.dart';
import 'package:my_example_file/home/posts/views/create_post/widgets/custom_text_field.dart';
import 'package:my_example_file/home/posts/views/create_post/widgets/image_preview.dart';
import 'package:my_example_file/home/posts/views/create_post/widgets/location_selector.dart';
import 'package:my_example_file/home/posts/views/create_post/widgets/sub_location_selector.dart';
import 'package:my_example_file/home/posts/views/create_post/widgets/subcategory_selector.dart';
import 'package:my_example_file/home/posts/models/location_model.dart';
import 'package:my_example_file/services/image_service.dart';
import 'package:my_example_file/services/firebase_service.dart';
import 'package:my_example_file/home/posts/models/category_model.dart';

class CreatePostForm extends StatefulWidget {
  @override
  _CreatePostFormState createState() => _CreatePostFormState();
}

class _CreatePostFormState extends State<CreatePostForm> {
  final _formKey = GlobalKey<FormState>();
  final _captionController = TextEditingController();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _locationController = TextEditingController();
  final _socialMediaLink = TextEditingController();
  final _phoneNumberController = TextEditingController();
  List<Uint8List> _images = [];
  List<String> _imageUrls = [];
  final List<SubCategoryModel> _selectedSubcategories = [];
  final List<SubLocationModel> _selectedSubLocations = [];
  final List<CategoryModel> _selectedCategories = [];
  final List<LocationModel> _selectedLocations = [];
  String? _selectedCurrency;
  String? _selectedTransactionType;
  final ImageService _imageService = ImageService();
  final FirebaseService _firebaseService = FirebaseService();
  final List<String> _currencyOptions = ['RUB', 'USD', 'SOM'];
  final List<String> _transactionTypeOptions = [
    'Продам',
    'Куплю',
    'Сдам',
    'Сниму'
  ];

  @override
  void dispose() {
    _captionController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _locationController.dispose();
    _socialMediaLink.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _selectImages() async {
    final selectedImages = await _imageService.selectAndCompressImages();
    if (selectedImages.isNotEmpty) {
      final uploadedUrls =
          await _firebaseService.uploadImagesToFirebase(selectedImages);
      setState(() {
        _images = selectedImages;
        _imageUrls = uploadedUrls;
      });
    }
  }

  Future<void> _createPost() async {
    if (!_formKey.currentState!.validate() || _images.isEmpty) {
      _showSnackBar(
          'Сураныч, бардык талааларды толтуруңуз жана сүрөттөрдү тандаңыз');
      return;
    }

    if (_selectedCategories.isEmpty && _selectedSubcategories.isEmpty) {
      _showSnackBar(
          'Сураныч, жок дегенде бир категория же подкатегория тандаңыз');
      return;
    }

    if (_selectedCurrency == null || _selectedTransactionType == null) {
      _showSnackBar('Сураныч, валюта жана транзакция түрүн тандаңыз');
      return;
    }

    try {
      List<String> imageUrls = await _uploadImages();

      List<Map<String, dynamic>> formattedCategories = [];
      List<Map<String, dynamic>> formattedLocations = [];

      for (var category in _selectedCategories) {
        formattedCategories.add({
          'id': category.id,
          'name': category.name,
          'subcategories': [],
        });
      }

      for (var subcategory in _selectedSubcategories) {
        var parentCategory = _findParentCategory(subcategory);
        if (parentCategory != null) {
          var categoryIndex = formattedCategories
              .indexWhere((cat) => cat['id'] == parentCategory.id);
          if (categoryIndex == -1) {
            formattedCategories.add({
              'id': parentCategory.id,
              'name': parentCategory.name,
              'subcategories': [
                {
                  'id': subcategory.id,
                  'name': subcategory.name,
                }
              ],
            });
          } else {
            formattedCategories[categoryIndex]['subcategories'].add({
              'id': subcategory.id,
              'name': subcategory.name,
            });
          }
        }
      }

      for (var location in _selectedLocations) {
        formattedLocations.add({
          'id': location.id,
          'name': location.name,
          'subLocation': _formatSubLocations(location
              .subLocations), 
        });
      }

      final postBloc = context.read<PostBloc>();
      postBloc.add(
        CreatePost(
          imageUrls: imageUrls,
          caption: _captionController.text,
          name: _nameController.text,
          price: int.parse(_priceController.text),
          location: formattedLocations,
          category: formattedCategories,
          socialMediaLink: _socialMediaLink.text,
          currency: _selectedCurrency!,
          transactionType: _selectedTransactionType!,
          phoneNumber: _phoneNumberController.text,
        ),
      );

      final state = await postBloc.stream
          .firstWhere((state) => state is PostCreated || state is PostError);
      if (state is PostCreated) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => MainScreen(),
          ),
        );
      } else if (state is PostError) {
        _showSnackBar('Пост түзүүдө ката кетти: ${(state as PostError).error}');
      }
    } catch (e) {
      _showSnackBar('Пост түзүүдө ката кетти: $e');
    }
  }

  List<Map<String, dynamic>> _formatSubLocations(
      List<SubLocationModel> subLocations) {
    return subLocations
        .map((subLocation) => {
              'id': subLocation.id,
              'name': subLocation.name,
            })
        .toList();
  }

  CategoryModel? _findParentCategory(SubCategoryModel subcategory) {
    for (var category in _selectedCategories) {
      if (_findSubcategoryInCategory(category, subcategory)) {
        return category;
      }
    }
    return null;
  }

  bool _findSubcategoryInCategory(
      CategoryModel category, SubCategoryModel subcategory) {
    List<SubCategoryModel> allSubcategories = [];
    void flattenSubcategories(List<SubCategoryModel> subcategories) {
      for (var subcat in subcategories) {
        allSubcategories.add(subcat);
        flattenSubcategories(subcat.subcategories);
      }
    }

    flattenSubcategories(category.subcategories);
    return allSubcategories.any((subcat) => subcat.id == subcategory.id);
  }

  Future<List<String>> _uploadImages() async {
    return Future.wait(_images.indexed.map((indexedImage) {
      int index = indexedImage.$1;
      Uint8List imageData = indexedImage.$2;
      String imagePath =
          'posts/${DateTime.now().millisecondsSinceEpoch}_$index.jpg';
      return FirebaseStorageHelper.uploadImageToStorage(imagePath, imageData);
    }));
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: _selectImages,
                child: const Text('Выбрать изображения'),
              ),
              const SizedBox(height: 16),
              if (_images.isNotEmpty) ImagePreview(images: _imageUrls),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _nameController,
                label: 'Название продукта',
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _priceController,
                label: 'Цена',
                keyboardType: TextInputType.number,
                validator: _priceValidator,
              ),
              const SizedBox(height: 8),
              LocationSelector(
                  selectedLocations: _selectedLocations,
                  onLocationSelected: (location) {
                    setState(() {
                      _selectedLocations.add(location);
                    });
                  },
                  locations: Region().locationsList),
              const SizedBox(height: 8),
              SubLocationSelector(
                selectedSubLocations: _selectedSubLocations,
                onSubLocationSelected: (subLocation) {
                  setState(() {
                    _selectedSubLocations.add(subLocation);
                  });
                },
                selectedLocations: _selectedLocations,
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: _captionController,
                label: 'Текст поста',
                maxLines: 3,
                validator: _requiredValidator,
              ),
              const SizedBox(height: 16),
              CategorySelector(
                selectedCategories: _selectedCategories,
                onCategorySelected: (category) {
                  setState(() {
                    _selectedCategories.add(category);
                  });
                },
                categories: Categories().categories,
              ),
              const SizedBox(height: 16),
              SubcategorySelector(
                selectedSubcategories: _selectedSubcategories,
                onSubcategorySelected: (subcategory) {
                  setState(() {
                    _selectedSubcategories.add(subcategory);
                  });
                },
                selectedCategories: _selectedCategories,
              ),
              const SizedBox(height: 16),
              CustomDropdown(
                value: _selectedCurrency,
                items: _currencyOptions,
                hint: 'Валютаны тандоо',
                onChanged: (value) {
                  setState(() {
                    _selectedCurrency = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              CustomDropdown(
                value: _selectedTransactionType,
                items: _transactionTypeOptions,
                hint: 'Транзакция түрүн тандоо',
                onChanged: (value) {
                  setState(() {
                    _selectedTransactionType = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _socialMediaLink,
                label: 'Instagram ссылка',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _phoneNumberController,
                label: 'Номер телефона',
                keyboardType: TextInputType.phone,
                validator: _requiredValidator,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _createPost,
                child: const Text('Опубликовать пост'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Бул талааны толтуруу милдеттүү';
    }
    return null;
  }

  String? _priceValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Сураныч, баасын киргизиңиз';
    }
    if (double.tryParse(value) == null) {
      return 'Сураныч, туура санды киргизиңиз';
    }
    return null;
  }
}
