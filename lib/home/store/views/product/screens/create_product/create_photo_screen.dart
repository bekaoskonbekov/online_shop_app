import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:my_example_file/home/store/views/product/screens/create_product/create_pro.dart';
import 'package:my_example_file/services/image_service.dart';
import 'package:my_example_file/services/firebase_service.dart';

class CreateProductPhotoScreen extends StatefulWidget {
  final String categoryId;
  final String storeId;
  const CreateProductPhotoScreen({
    Key? key,
    required this.categoryId,
    required this.storeId,
  }) : super(key: key);
  @override
  _CreateProductPhotoScreenState createState() => _CreateProductPhotoScreenState();
}
class _CreateProductPhotoScreenState extends State<CreateProductPhotoScreen> {
  final ImageService _imageService = ImageService();
  final FirebaseService _firebaseService = FirebaseService();
  List<String> _imageUrls = [];
  bool _isUploading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Продукт сүрөттөрү'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImagePicker(),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _imageUrls.isNotEmpty && !_isUploading
                  ? _navigateToCreateProductScreen
                  : null,
              child: Text('Далее'),
            ),
            if (_isUploading) 
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
  Widget _buildImagePicker() {
    return Container(
      height: 120,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          ..._imageUrls.map((url) => _buildImagePreview(url)).toList(),
          _buildAddImageButton(),
        ],
      ),
    );
  }
  Widget _buildImagePreview(String url) {
    return Padding(
      padding: EdgeInsets.only(right: 8),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              url,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 0,
            right: 0,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: () => setState(() => _imageUrls.remove(url)),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildAddImageButton() {
    return InkWell(
      onTap: _pickAndUploadImages,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(Icons.add_photo_alternate, size: 40, color: Colors.grey),
      ),
    );
  }
  Future<void> _pickAndUploadImages() async {
    setState(() => _isUploading = true);
    try {
      List<Uint8List> selectedImages = await _imageService.selectAndCompressImages();
      if (selectedImages.isNotEmpty) {
        List<String> uploadedUrls = await _firebaseService.uploadImagesToFirebase(selectedImages);
        setState(() {
          _imageUrls.addAll(uploadedUrls);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Сүрөт жүктөөдө ката кетти: $e')),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }
  void _navigateToCreateProductScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CreateProductScreen(
          categoryId: widget.categoryId,
          storeId: widget.storeId,
          imageUrls: _imageUrls,
        ),
      ),
    );
  }
}