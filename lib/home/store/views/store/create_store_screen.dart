import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_example_file/home/store/bloc/store/store_bloc.dart';
import 'package:my_example_file/home/store/bloc/store/store_event.dart';
import 'package:my_example_file/home/store/bloc/store/store_state.dart';

class CreateStoreScreen extends StatefulWidget {
  final String uid;

  const CreateStoreScreen({super.key, required this.uid});

  @override
  _CreateStoreScreenState createState() => _CreateStoreScreenState();
}

class _CreateStoreScreenState extends State<CreateStoreScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storeNameController = TextEditingController();
  final _storeDescriptionController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  final _addressController = TextEditingController();
  String? _selectedBannerImage;
  String? _bannerUrl;
  Map<String, String> _businessHours = {};
  List<String> _socialMediaLinks = [];

  @override
  void dispose() {
    _storeNameController.dispose();
    _storeDescriptionController.dispose();
    _contactPhoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedBannerImage = image.path;
      });
    }
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('store_banners/${DateTime.now().millisecondsSinceEpoch}');
      final uploadTask = storageRef.putFile(imageFile);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Image upload failed: $e');
      return null;
    }
  
  }

   void _addBusinessHours() {
    showDialog(
      context: context,
      builder: (context) {
        String day = '';
        String hours = '';
        return AlertDialog(
          title: Text('Add Business Hours'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => day = value,
                decoration:
                    InputDecoration(hintText: "Enter day (e.g., Monday)"),
              ),
              TextField(
                onChanged: (value) => hours = value,
                decoration: InputDecoration(
                    hintText: "Enter hours (e.g., 9:00 AM - 5:00 PM)"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (day.isNotEmpty && hours.isNotEmpty) {
                  setState(() {
                    _businessHours[day] = hours;
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _addSocialMediaLink() {
    showDialog(
      context: context,
      builder: (context) {
        String newLink = '';
        return AlertDialog(
          title: Text('Add Social Media Link'),
          content: TextField(
            onChanged: (value) => newLink = value,
            decoration: InputDecoration(hintText: "Enter social media link"),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (newLink.isNotEmpty) {
                  setState(() {
                    _socialMediaLinks.add(newLink);
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedBannerImage != null) {
        _bannerUrl = await _uploadImage(File(_selectedBannerImage!));
      }

      if (_bannerUrl == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload banner image')),
        );
        return;
      }

      context.read<StoreBloc>().add(CreateStoreEvent(
            userId: widget.uid,
            storeBannerUrl: _bannerUrl!,
            storeName: _storeNameController.text,
            storeDescription: _storeDescriptionController.text,
            contactPhone: _contactPhoneController.text,
            address: _addressController.text,
            businessHours: _businessHours,
            socialMediaLinks: _socialMediaLinks,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Store'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _submitForm,
          ),
        ],
      ),
      body: BlocListener<StoreBloc, StoreState>(
        listener: (context, state) {
          if (state is StoreLoading) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Дукон ийгиликтуу тузулду')),
            );
            Navigator.of(context).pop();
          } else if (state is StoreError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _selectedBannerImage != null
                        ? Image.file(File(_selectedBannerImage!),
                            fit: BoxFit.cover)
                        : Icon(Icons.add_a_photo,
                            size: 50, color: Colors.grey[400]),
                  ),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _storeNameController,
                  decoration: InputDecoration(
                    labelText: 'Store Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a store name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _storeDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Store Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _contactPhoneController,
                  decoration: InputDecoration(
                    labelText: 'Contact Phone',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addBusinessHours,
                  child: Text('Add Business Hours'),
                ),
                if (_businessHours.isNotEmpty) ..._businessHours.entries.map(
                  (entry) {
                    return ListTile(
                      title: Text('${entry.key}: ${entry.value}'),
                    );
                  },
                ).toList(),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addSocialMediaLink,
                  child: Text('Add Social Media Link'),
                ),
                if (_socialMediaLinks.isNotEmpty) ..._socialMediaLinks.map(
                  (link) {
                    return ListTile(
                      title: Text(link),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _socialMediaLinks.remove(link);
                          });
                        },
                      ),
                    );
                  },
                ).toList(),
                SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
