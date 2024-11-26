import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/home/store/bloc/country_of_origin/country_of_origin_event.dart';
import 'package:my_example_file/home/store/bloc/country_of_origin/country_of_origin_state.dart';
import 'package:my_example_file/home/store/repositories/country_of_origin_repository.dart';
class CountryBloc extends Bloc<CountryEvent, CountryState> {
  final CountryOfOriginRepository _countryRepository;

  CountryBloc({required CountryOfOriginRepository countryRepository})
      : _countryRepository = countryRepository,
        super(CountryInitial()) {
    on<LoadCountries>(_onLoadCountries);
    on<LoadCountry>(_onLoadCountry);
     on<InitializeCountries>(_onInitializeCountries);
  
  }
  Future<void> _onLoadCountries(LoadCountries event, Emitter<CountryState> emit) async {
    emit(CountryLoading());
    try {
      final countries = await _countryRepository.getAllCountries();
      emit(CountriesLoaded(countries));
    } catch (e) {
      emit(CountryError(e.toString()));
    }
  }
  Future<void> _onLoadCountry(LoadCountry event, Emitter<CountryState> emit) async {
    emit(CountryLoading());
    try {
      final country = await _countryRepository.getCountryById(event.countryId);
      if (country != null) {
        emit(CountryLoaded(country));
      } else {
        emit(CountryError('Өлкө табылган жок'));
      }
    } catch (e) {
      emit(CountryError(e.toString()));
    }
  }
  Future<void> _onInitializeCountries(InitializeCountries event, Emitter<CountryState> emit) async {
    emit(CountryLoading());
    try {
      await _countryRepository.initializeCountries(event.countries);
      emit(CountryOperationSuccess());
    } catch (e) {
      emit(CountryError(e.toString()));
    }
  }
}