
// States
import 'package:equatable/equatable.dart';
import 'package:my_example_file/home/store/models/country_of_origin_model.dart';

abstract class CountryState extends Equatable {
  const CountryState();
  
  @override
  List<Object> get props => [];
}

class CountryInitial extends CountryState {}

class CountryLoading extends CountryState {}

class CountriesLoaded extends CountryState {
  final List<CountryOfOriginModel> countries;

  const CountriesLoaded(this.countries);

  @override
  List<Object> get props => [countries];
}

class CountryLoaded extends CountryState {
  final CountryOfOriginModel country;

  const CountryLoaded(this.country);

  @override
  List<Object> get props => [country];
}

class CountryOperationSuccess extends CountryState {}

class CountryError extends CountryState {
  final String message;

  const CountryError(this.message);

  @override
  List<Object> get props => [message];
}