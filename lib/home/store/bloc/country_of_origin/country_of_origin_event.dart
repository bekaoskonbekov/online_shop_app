import 'package:equatable/equatable.dart';
abstract class CountryEvent extends Equatable {
  const CountryEvent();
  @override
  List<Object> get props => [];
}
class LoadCountries extends CountryEvent {}
class LoadCountry extends CountryEvent {
  final String countryId;
  const LoadCountry(this.countryId);
  @override
  List<Object> get props => [countryId];
}
class AddCountry extends CountryEvent {
  final String name;
  final String code;
  final String? flagImage;
  const AddCountry({required this.name, required this.code, this.flagImage});
  @override
  List<Object> get props => [name, code, if (flagImage != null) flagImage!];
}

class AddProductToCountry extends CountryEvent {
  final String countryId;
  final String productId;

  const AddProductToCountry(this.countryId, this.productId);

  @override
  List<Object> get props => [countryId, productId];
}

class RemoveProductFromCountry extends CountryEvent {
  final String countryId;
  final String productId;

  const RemoveProductFromCountry(this.countryId, this.productId);

  @override
  List<Object> get props => [countryId, productId];
}

class InitializeCountries extends CountryEvent {
  final List<Map<String, dynamic>> countries;

  const InitializeCountries(this.countries);

  @override
  List<Object> get props => [countries];
}
