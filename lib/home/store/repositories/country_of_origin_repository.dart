import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_example_file/home/store/models/country_of_origin_model.dart';
import 'package:my_example_file/home/store/repositories/base_repository.dart';


class CountryOfOriginRepository extends BaseRepository<CountryOfOriginModel> {
  CountryOfOriginRepository({FirebaseFirestore? firestore})
      : super(firestore ?? FirebaseFirestore.instance, 'countries_of_origin');

  @override
  CountryOfOriginModel fromFirestore(DocumentSnapshot doc) {
    return CountryOfOriginModel.fromFirestore(doc);
  }

  Future<void> initializeCountries(List<Map<String, dynamic>> countries) async {
    try {
      await initialize(countries);
    } catch (e) {
      throw handleException('Өлкөлөрдү инициализациялоодо ката кетти', e);
    }
  }

  Future<List<CountryOfOriginModel>> getAllCountries() async {
    return getAll();
  }

  Future<CountryOfOriginModel?> getCountryById(String countryId) async {
    return getById(countryId);
  }
 Future<void> addProductToCountry(String productId, String countryId) async {
    return addToArray(countryId, 'productIds', productId);
  }
}
