// import 'dart:typed_data';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:image_picker/image_picker.dart' as picker;
// import 'package:my_example_file/blocs/post/post_bloc.dart';
// import 'package:my_example_file/blocs/post/post_event.dart';
// import 'package:my_example_file/blocs/post/post_state.dart';
// import 'package:my_example_file/core/helpers/firebase_storage_helper.dart';
// import 'package:my_example_file/core/utils/util.dart';
// import 'package:my_example_file/models/category_model.dart';
// import 'package:my_example_file/models/subcategory_model.dart';
// import 'package:my_example_file/services/firebase_service.dart';
// import 'package:my_example_file/services/image_service.dart';

// class CreatePostScreen extends StatefulWidget {
//   const CreatePostScreen({Key? key}) : super(key: key);

//   @override
//   _CreatePostScreenState createState() => _CreatePostScreenState();
// }

// class _CreatePostScreenState extends State<CreatePostScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _captionController = TextEditingController();
//   final _nameController = TextEditingController();
//   final _priceController = TextEditingController();
//   final _locationController = TextEditingController();
//   final _socialMediaLink = TextEditingController();
//   final _phoneNumberController = TextEditingController();

//   List<Uint8List> _images = [];
//   List<String> _imageUrls = [];
//   final picker.ImagePicker _picker = picker.ImagePicker();
//   final List<SubCategoryModel> _selectedSubcategories = [];
//   final List<CategoryModel> _selectedCategories = [];
//   String? _selectedCurrency;
//   String? _selectedTransactionType;
// final ImageService _imageService = ImageService();
//   final FirebaseService _firebaseService = FirebaseService();
//   final List<String> _currencyOptions = ['RUB', 'USD', 'SOM'];
//   final List<String> _transactionTypeOptions = [
//     'Продам',
//     'Куплю',
//     'Сдам',
//     'Сниму'
//   ];

//   @override
//   void dispose() {
//     _captionController.dispose();
//     _nameController.dispose();
//     _priceController.dispose();
//     _locationController.dispose();
//     _socialMediaLink.dispose();
//     _phoneNumberController.dispose();
//     super.dispose();
//   }

//  Future<void> _selectImages() async {
//     _images = await _imageService.selectAndCompressImages();
//     setState(() {});

//     if (_images.isNotEmpty) {
//       _imageUrls = await _firebaseService.uploadImagesToFirebase(_images);
//       setState(() {});
//     }
//   }

 

//   Future<void> _createPost() async {
//     if (!_formKey.currentState!.validate() || _images.isEmpty) {
//       _showSnackBar(
//           'Сураныч, бардык талааларды толтуруңуз жана сүрөттөрдү тандаңыз');
//       return;
//     }

//     if (_selectedCategories.isEmpty && _selectedSubcategories.isEmpty) {
//       _showSnackBar(
//           'Сураныч, жок дегенде бир категория же подкатегория тандаңыз');
//       return;
//     }

//     if (_selectedCurrency == null || _selectedTransactionType == null) {
//       _showSnackBar('Сураныч, валюта жана транзакция түрүн тандаңыз');
//       return;
//     }

//     try {
//       List<String> imageUrls = await _uploadImages();

//       List<Map<String, dynamic>> formattedCategories = [];

//       for (var category in _selectedCategories) {
//         formattedCategories.add({
//           'id': category.id,
//           'name': category.name,
//           'subcategories': [],
//         });
//       }

//       for (var subcategory in _selectedSubcategories) {
//         var parentCategory = _findParentCategory(subcategory);
//         if (parentCategory != null) {
//           var categoryIndex = formattedCategories
//               .indexWhere((cat) => cat['id'] == parentCategory.id);
//           if (categoryIndex == -1) {
//             formattedCategories.add({
//               'id': parentCategory.id,
//               'name': parentCategory.name,
//               'subcategories': [
//                 {
//                   'id': subcategory.id,
//                   'name': subcategory.name,
//                 }
//               ],
//             });
//           } else {
//             formattedCategories[categoryIndex]['subcategories'].add({
//               'id': subcategory.id,
//               'name': subcategory.name,
//             });
//           }
//         }
//       }

//       context.read<PostBloc>().add(
//             CreatePost(
//               imageUrls: imageUrls,
//               caption: _captionController.text,
//               name: _nameController.text,
//               price: int.parse(_priceController.text),
//               location: _locationController.text,
//               category: formattedCategories,
//               socialMediaLink: _socialMediaLink.text,
//               currency: _selectedCurrency!,
//               transactionType: _selectedTransactionType!,
//               phoneNumber: _phoneNumberController.text,
//             ),
//           );
//     } catch (e) {
//       _showSnackBar('Пост түзүүдө ката кетти: $e');
//     }
//   }

//   CategoryModel? _findParentCategory(SubCategoryModel subcategory) {
//     for (var category in _selectedCategories) {
//       if (_findSubcategoryInCategory(category, subcategory)) {
//         return category;
//       }
//     }
//     return null;
//   }

//   bool _findSubcategoryInCategory(
//       CategoryModel category, SubCategoryModel subcategory) {
//     for (var subCategory in category.subcategories) {
//       if (subCategory.id == subcategory.id) {
//         return true;
//       }
//       if (subCategory.subcategories.isNotEmpty) {
//         if (_findSubcategoryInCategory(
//           CategoryModel(
//               id: subCategory.id,
//               name: subCategory.name,
//               subcategories: subCategory.subcategories),
//           subcategory,
//         )) {
//           return true;
//         }
//       }
//     }
//     return false;
//   }

//   Future<List<String>> _uploadImages() async {
//     return Future.wait(_images.asMap().entries.map((entry) {
//       int index = entry.key;
//       Uint8List imageData = entry.value;
//       String imagePath =
//           'posts/${DateTime.now().millisecondsSinceEpoch}_$index.jpg';
//       return FirebaseStorageHelper.uploadImageToStorage(imagePath, imageData);
//     }));
//   }

//   void _showSnackBar(String message) {
//     ScaffoldMessenger.of(context)
//         .showSnackBar(SnackBar(content: Text(message)));
//   }

//  void _showCurrencyBottomSheet() {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (BuildContext context) {
//       return _buildBottomSheet(
//         title: 'Валютаны тандоо',
//         options: _currencyOptions,
//         onSelected: (value) {
//           setState(() {
//             _selectedCurrency = value;
//           });
//         },
//       );
//     },
//   );
// }

// void _showTransactionTypeBottomSheet() {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (BuildContext context) {
//       return _buildBottomSheet(
//         title: 'Транзакция түрүн тандоо',
//         options: _transactionTypeOptions,
//         onSelected: (value) {
//           setState(() {
//             _selectedTransactionType = value;
//           });
//         },
//       );
//     },
//   );
// }

// Widget _buildBottomSheet({
//   required String title,
//   required List<String> options,
//   required ValueChanged<String> onSelected,
// }) {
//   return StatefulBuilder(
//     builder: (BuildContext context, setState) {
//       return DraggableScrollableSheet(
//         initialChildSize: 0.7,
//         minChildSize: 0.2,
//         maxChildSize: 0.95,
//         builder: (_, controller) {
//           return Container(
//             decoration: BoxDecoration(
//               color: Theme.of(context).canvasColor,
//               borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//             ),
//             child: Column(
//               children: [
//                 AppBar(
//                   title: Text(title),
//                   backgroundColor: Colors.transparent,
//                   elevation: 0,
//                   actions: [
//                     IconButton(
//                       icon: const Icon(Icons.close),
//                       onPressed: () => Navigator.pop(context),
//                     ),
//                   ],
//                 ),
//                 Expanded(
//                   child: ListView.builder(
//                     controller: controller,
//                     itemCount: options.length,
//                     itemBuilder: (context, index) {
//                       return ListTile(
//                         title: Text(options[index], style: TextStyle(fontWeight: FontWeight.bold),),
//                         onTap: () {
//                           onSelected(options[index]);
//                           Navigator.pop(context);
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       );
//     },
//   );
// }

//  void _showCategoryBottomSheet() {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (BuildContext context) {
//       return StatefulBuilder(
//         builder: (BuildContext context, StateSetter setModalState) {
//           return DraggableScrollableSheet(
//             initialChildSize: 0.7,
//             minChildSize: 0.2,
//             maxChildSize: 0.95,
//             builder: (_, controller) {
//               return Container(
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).canvasColor,
//                   borderRadius:
//                       const BorderRadius.vertical(top: Radius.circular(20)),
//                 ),
//                 child: Column(
//                   children: [
//                     AppBar(
//                       title: const Text('Категория тандоо'),
//                       backgroundColor: Colors.transparent,
//                       elevation: 0,
//                       actions: [
//                         IconButton(
//                           icon: const Icon(Icons.close),
//                           onPressed: () => Navigator.pop(context),
//                         ),
//                       ],
//                     ),
//                     Expanded(
//                       child: ListView.builder(
//                         controller: controller,
//                         itemCount: Categories().categories.length,
//                         itemBuilder: (context, index) {
//                           return _buildCategoryTile(
//                               Categories().categories[index], setModalState);
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       );
//     },
//   );
// }

// void _showSubCategoryBottomSheet(CategoryModel category) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.transparent,
//     builder: (BuildContext context) {
//       return StatefulBuilder(
//         builder: (BuildContext context, StateSetter setModalState) {
//           return DraggableScrollableSheet(
//             initialChildSize: 0.7,
//             minChildSize: 0.2,
//             maxChildSize: 0.95,
//             builder: (_, controller) {
//               return Container(
//                 decoration: BoxDecoration(
//                   color: Theme.of(context).canvasColor,
//                   borderRadius:
//                       const BorderRadius.vertical(top: Radius.circular(20)),
//                 ),
//                 child: Column(
//                   children: [
//                     AppBar(
//                       title: Text('Подкатегория тандоо: ${category.name}'),
//                       backgroundColor: Colors.transparent,
//                       elevation: 0,
//                       actions: [
//                         IconButton(
//                           icon: const Icon(Icons.close),
//                           onPressed: () => Navigator.pop(context),
//                         ),
//                       ],
//                     ),
//                     Expanded(
//                       child: ListView(
//                         controller: controller,
//                         children: _buildSubcategories(
//                             category.subcategories, setModalState),
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//       );
//     },
//   );
// }




//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Создать новый пост')),
//       body: BlocConsumer<PostBloc, PostState>(
//         listener: (context, state) {
//           if (state is PostCreated) {
//             _showSnackBar('Пост успешно создан');
//             Navigator.of(context).pop();
//           } else if (state is PostError) {
//             _showSnackBar(state.error);
//           }
//         },
//         builder: (context, state) {
//           return SingleChildScrollView(
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: [
//                     ElevatedButton(
//                       onPressed: _selectImages,
//                       child: const Text('Выбрать изображения'),
//                     ),
//                     const SizedBox(height: 16),
//                     if (_images.isNotEmpty) _buildImagePreview(),
//                     const SizedBox(height: 8),
//                     _buildTextField(_nameController, 'Название продукта'),
//                     const SizedBox(height: 8),
//                     _buildTextField(
//                       _priceController,
//                       'Цена',
//                       keyboardType: TextInputType.number,
//                       validator: _priceValidator,
//                     ),
//                     const SizedBox(height: 8),
//                     _buildTextField(
//                       _locationController,
//                       'Местоположение',
//                       validator: _requiredValidator,
//                     ),
//                     const SizedBox(height: 8),
//                     _buildTextField(
//                       _captionController,
//                       'Текст поста',
//                       maxLines: 3,
//                       validator: _requiredValidator,
//                     ),
//                     const SizedBox(height: 16),
//                     _buildCategorySelector(),
//                     const SizedBox(height: 16),
//                     _buildSubCategorySelector(),
//                     const SizedBox(height: 16),
//                     _buildCurrencySelector(),
//                     const SizedBox(height: 16),
//                     _buildTransactionTypeSelector(),
//                     const SizedBox(height: 16),
//                     _buildTextField(
//                       _socialMediaLink,
//                       'Instagram ссылка',
//                     ),
//                     const SizedBox(height: 16),
//                     _buildTextField(
//                       _phoneNumberController,
//                       'Номер телефона',
//                       keyboardType: TextInputType.phone,
//                       validator: _requiredValidator,
//                     ),
//                     const SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed: state is PostLoading ? null : _createPost,
//                       child: state is PostLoading
//                           ? const CircularProgressIndicator()
//                           : const Text('Опубликовать пост'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }


// // Сүрөттөрдү көрсөтүү үчүн колдонуу
//  Widget _buildImagePreview() {
//     return SizedBox(
//       height: 200,
//       child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: _imageUrls.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: CachedNetworkImage(
//               imageUrl: _imageUrls[index],
//               placeholder: (context, url) => const CircularProgressIndicator(),
//               errorWidget: (context, url, error) => const Icon(Icons.error),
//             ),
//           );
//         },
//       ),
//     );
//   }

 






//   Widget _buildTextField(
//     TextEditingController controller,
//     String label, {
//     int maxLines = 1,
//     TextInputType? keyboardType,
//     String? Function(String?)? validator,
//   }) {
//     return TextFormField(
//       controller: controller,
//       decoration: InputDecoration(
//         labelText: label,
//         border: const OutlineInputBorder(),
//       ),
//       maxLines: maxLines,
//       keyboardType: keyboardType,
//       validator: validator,
//     );
//   }

//   Widget _buildCategoryTile(CategoryModel category, StateSetter setModalState) {
//     bool isSelected = _selectedCategories.contains(category);
//     return ListTile(
//       title: Text(category.name, style: TextStyle(fontWeight: FontWeight.bold),),
//       trailing:
//           isSelected ? const Icon(Icons.check, color: Colors.green) : null,
//       onTap: () {
//         setModalState(() {
//           if (isSelected) {
//             _selectedCategories.remove(category);
//             Navigator.pop(context);
//           } else {
//             _selectedCategories.add(category);
//             Navigator.pop(context);
//           }
//         });
//         setState(() {});
//       },
//     );
//   }

//   List<Widget> _buildSubcategories(
//       List<SubCategoryModel> subcategories, StateSetter setModalState) {
//     return subcategories.map((subcategory) {
//       bool isSelected = _selectedSubcategories.contains(subcategory);
//       return ListTile(
//         title: Text(subcategory.name, style: TextStyle(fontWeight: FontWeight.bold),),
//         onTap: () {
//           setModalState(() {
//             if (isSelected) {
//               _selectedSubcategories.remove(subcategory);
//               Navigator.pop(context);
//             } else {
//               _selectedSubcategories.add(subcategory);
//               Navigator.pop(context);
//             }
//           });
//           setState(() {});
//         },
//       );
//     }).toList();
//   }

//   Widget _buildCategorySelector() {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color.fromARGB(255, 26, 26, 27),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: ListTile(
//         title: Text(
//           _selectedCategories.isEmpty
//               ? 'Категория тандоо'
//               : _selectedCategories.map((c) => c.name).join(', '),
//           style: const TextStyle(color: Colors.white),
//         ),
//         trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
//         onTap: () => _showCategoryBottomSheet(),
//       ),
//     );
//   }

//   Widget _buildSubCategorySelector() {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color.fromARGB(255, 26, 26, 27),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: ListTile(
//         title: Text(
//           _selectedSubcategories.isEmpty
//               ? 'Подкатегория тандоо'
//               : _selectedSubcategories.map((s) => s.name).join(', '),
//           style: const TextStyle(color: Colors.white),
//         ),
//         trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
//         onTap: () {
//           if (_selectedCategories.isNotEmpty) {
//             _showSubCategoryBottomSheet(_selectedCategories.first);
//           } else {
//             _showSnackBar('Алгач категория тандаңыз');
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildCurrencySelector() {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color.fromARGB(255, 26, 26, 27),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: ListTile(
//         title: Text(
//           _selectedCurrency == null ? 'Валютаны тандоо' : _selectedCurrency!,
//           style: const TextStyle(color: Colors.white),
//         ),
//         trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
//         onTap: () => _showCurrencyBottomSheet(),
//       ),
//     );
//   }

//   Widget _buildTransactionTypeSelector() {
//     return Container(
//       decoration: BoxDecoration(
//         color: const Color.fromARGB(255, 26, 26, 27),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: ListTile(
//         title: Text(
//           _selectedTransactionType == null
//               ? 'Транзакция түрүн тандоо'
//               : _selectedTransactionType!,
//           style: const TextStyle(color: Colors.white),
//         ),
//         trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
//         onTap: () => _showTransactionTypeBottomSheet(),
//       ),
//     );
//   }

//   String? _requiredValidator(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Бул талааны толтуруу милдеттүү';
//     }
//     return null;
//   }

//   String? _priceValidator(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Сураныч, баасын киргизиңиз';
//     }
//     if (double.tryParse(value) == null) {
//       return 'Сураныч, туура санды киргизиңиз';
//     }
//     return null;
//   }
// }
