import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_example_file/blocs/profile/profile_bloc.dart';
import 'package:my_example_file/blocs/profile/profile_event.dart';
import 'package:my_example_file/blocs/profile/profile_state.dart';
import 'package:my_example_file/home/user_info/repositoris/user_info_repository.dart';

class EditProfileScreen extends StatefulWidget {
  final String uid;

  const EditProfileScreen({Key? key, required this.uid}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _bioController = TextEditingController();
  final _emailController = TextEditingController();
  final _locationController = TextEditingController();
  final _nameController = TextEditingController();
  final _urlController = TextEditingController();
  final _usernameController = TextEditingController();
  Uint8List? _profileImage;
  Map<String, dynamic>? _profileData;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profileData =
        await RepositoryProvider.of<EditProfileRepository>(context)
            .getProfile(widget.uid);
    if (profileData != null) {
      setState(() {
        _profileData = profileData;
        _bioController.text = profileData['bio'] ?? '';
        _emailController.text = profileData['email'] ?? '';
        _locationController.text = profileData['location'] ?? '';
        _nameController.text = profileData['name'] ?? '';
        _urlController.text = profileData['url'] ?? '';
        _usernameController.text = profileData['username'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => EditProfileBloc(
        editrepository: RepositoryProvider.of<EditProfileRepository>(context),
      ),
      child: BlocConsumer<EditProfileBloc, EditProfileState>(
        listener: (context, state) {
          if (state is EditProfileSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Профиль ийгиликтүү жаңыртылды')),
            );
            Navigator.of(context).pop();
          } else if (state is EditProfileFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Ката: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(title: const Text('Профилди түзөтүү')),
            body: _profileData == null
                ? Center(child: CircularProgressIndicator())
                : Form(
                    key: _formKey,
                    child: ListView(
                      padding: const EdgeInsets.all(16.0),
                      children: [
                        // Profile Image Picker
                        GestureDetector(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: _profileImage != null
                                ? MemoryImage(_profileImage!)
                                : (_profileData!['photoUrl'] != null
                                    ? NetworkImage(_profileData!['photoUrl'])
                                    : null) as ImageProvider<Object>?,
                            child: _profileImage == null &&
                                    _profileData!['photoUrl'] == null
                                ? const Icon(Icons.add_a_photo, size: 50)
                                : null,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Аты'),
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                              labelText: 'Колдонуучу аты'),
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _bioController,
                          decoration: const InputDecoration(labelText: 'Био'),
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'Email'),
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _locationController,
                          decoration:
                              const InputDecoration(labelText: 'Жайгашуу'),
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _urlController,
                          decoration: const InputDecoration(labelText: 'URL'),
                          keyboardType: TextInputType.url,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              bool _validURL =
                                  Uri.tryParse(value)?.hasAbsolutePath ?? false;
                              if (!_validURL) {
                                return 'Жарактуу URL киргизиңиз';
                              }
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: state is EditProfileLoading
                              ? null
                              : () => _updateProfile(context),
                          child: state is EditProfileLoading
                              ? const CircularProgressIndicator()
                              : const Text('Профилди жаңыртуу'),
                        ),
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }

  Future<void> _pickImage() async {
    // Сүрөт тандоо логикасы
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      final Uint8List imageData = await image.readAsBytes();
      setState(() {
        _profileImage = imageData;
      });
    }
  }

  void _updateProfile(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<EditProfileBloc>().add(
            UpdateProfileRequested(
              uid: widget.uid,
              bio: _bioController.text,
              email: _emailController.text,
              location: _locationController.text,
              name: _nameController.text,
              url: _urlController.text,
              username: _usernameController.text,
              profileImage: _profileImage,
            ),
          );
    }
  }

  @override
  void dispose() {
    _bioController.dispose();
    _emailController.dispose();
    _locationController.dispose();
    _nameController.dispose();
    _urlController.dispose();
    _usernameController.dispose();
    super.dispose();
  }
}
