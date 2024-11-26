import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/home/store/product/clothing/blocs/clothing/clothing_event.dart';
import 'package:my_example_file/home/store/product/clothing/blocs/clothing/clothing_state.dart';
import 'package:my_example_file/home/store/product/clothing/repositories/clothing_repository.dart';
class ClothingBloc extends Bloc<ClothingEvent, ClothingState> {
  final ClothingRepository _clothingRepository;

  ClothingBloc({required ClothingRepository clothingRepository})
      : _clothingRepository = clothingRepository,
        super(ClothingInitial()) {
    on<LoadClothings>(_onLoadClothings);
  }

  Future<void> _onLoadClothings(
      LoadClothings event, Emitter<ClothingState> emit) async {
    emit(ClothingLoading());
    try {
      final clothings = await _clothingRepository.getAllClothings();
      emit(ClothingsLoaded(clothings));
    } catch (e) {
      emit(ClothingError('Кийимдерди жүктөөдө ката кетти: $e'));
    }
  }
}