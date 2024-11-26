import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:my_example_file/home/store/bloc/country_of_origin/country_of_origin_bloc.dart';
import 'package:my_example_file/home/store/bloc/country_of_origin/country_of_origin_event.dart';
import 'package:my_example_file/home/store/bloc/country_of_origin/country_of_origin_state.dart';
class CountryOfOriginManagementScreen extends StatefulWidget {
  const CountryOfOriginManagementScreen({Key? key}) : super(key: key);
  @override
  _CountryOfOriginManagementScreenState createState() => _CountryOfOriginManagementScreenState();
}
class _CountryOfOriginManagementScreenState extends State<CountryOfOriginManagementScreen> {
  final List<Map<String, dynamic>> _initialCountries = [
    {'name': 'Кыргызстан', 'code': 'KG', 'flagImage': 'kgz.png'},
    {'name': 'Казакстан', 'code': 'KZ', 'flagImage': 'kz.png'},
    {'name': 'Өзбекстан', 'code': 'UZ', 'flagImage': 'uz.png'},
    {'name': 'Россия', 'code': 'RU', 'flagImage': 'ru.png'},
    {'name': 'Түркия', 'code': 'TR', 'flagImage': 'tr.png'},
  ];
  bool _isInitialized = false;
  bool _isInitializing = false;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _buildFloatingActionButton(),
    );
  }
  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: _isInitialized || _isInitializing ? null : () => _initializeCountries(context),
      child: _isInitializing 
        ? const CircularProgressIndicator(color: Colors.white)
        : Icon(_isInitialized ? Icons.check : Icons.playlist_add),
      tooltip: _isInitialized 
        ? 'Өлкөлөр инициализацияланган' 
        : (_isInitializing ? 'Инициализация жүрүүдө...' : 'Бардык өлкөлөрдү кошуу'),
    );
  }
  Future<void> _initializeCountries(BuildContext context) async {
    if (_isInitializing) return;
    setState(() {
      _isInitializing = true;
    });
    try {
      final updatedCountries = await _uploadImagesToFirebase();
      await _initializeCountriesInFirestore(context, updatedCountries);
      setState(() {
        _isInitialized = true;
        _isInitializing = false;
      });
      _showSnackBar(context, 'Өлкөлөр ийгиликтүү инициализацияланды');
    } catch (e) {
      setState(() {
        _isInitializing = false;
      });
      _showSnackBar(context, 'Өлкөлөрдү инициализациялоодо ката кетти: $e');
    }
  }
  Future<List<Map<String, dynamic>>> _uploadImagesToFirebase() async {
    try {
      final updatedCountries = <Map<String, dynamic>>[];
      for (var country in _initialCountries) {
        try {
          final updatedCountry = await _uploadCountryImage(country);
          updatedCountries.add(updatedCountry);
        } catch (e) {
        }
      }
      return updatedCountries;
    } catch (e) {
      return _initialCountries;
    }
  }

  Future<Map<String, dynamic>> _uploadCountryImage(Map<String, dynamic> country) async {
    final updatedCountry = Map<String, dynamic>.from(country);
    if (country['flagImage'] != null) {
      try {
        final imageUrl = await _uploadImage(country['flagImage']);
        updatedCountry['flagImage'] = imageUrl;
      } catch (e) {
        updatedCountry['flagImage'] = null;
      }
    }
    return updatedCountry;
  }
  Future<String?> _uploadImage(String assetName) async {
    try {
      final byteData = await rootBundle.load('assets/images/flags/$assetName');
      final file = await File('${(await getTemporaryDirectory()).path}/$assetName').create();
      await file.writeAsBytes(byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      final ref = _storage.ref('flags/$assetName');
      await ref.putFile(file);
      return await ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }

  Future<void> _initializeCountriesInFirestore(BuildContext context, List<Map<String, dynamic>> countries) async {
    final countryBloc = context.read<CountryBloc>();
    try {
      countryBloc.add(InitializeCountries(countries));
      await for (final state in countryBloc.stream) {
        if (state is CountryOperationSuccess) {
          return;
        } else if (state is CountryError) {
          throw Exception(state.message);
        }
      }
    } catch (e) {
      throw Exception('Өлкөлөрдү Firestore\'го жүктөөдө ката кетти: $e');
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    ));
  }
}