import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/home/store/product/clothing/blocs/sizes/size_event.dart';
import 'package:my_example_file/home/store/product/clothing/blocs/sizes/size_state.dart';
import 'package:my_example_file/home/store/product/clothing/repositories/size_repository.dart';

class SizeBloc extends Bloc<SizeEvent, SizeState> {
  final SizeRepository _sizeRepository;

  SizeBloc({required SizeRepository sizeRepository})
      : _sizeRepository = sizeRepository,
        super(SizeInitial()) {
    on<GetSizes>(_onGetSizes);
    on<InitializeSizes>(_onInitializeSizes);
  }

  Future<void> _onGetSizes(GetSizes event, Emitter<SizeState> emit) async {
    emit(SizeLoading());
    try {
      final sizes = await _sizeRepository.getAll();
      emit(SizesLoaded(sizes));
    } catch (e) {
      emit(SizeError(e.toString()));
    }
  }

  Future<void> _onInitializeSizes(InitializeSizes event, Emitter<SizeState> emit) async {
    emit(SizeLoading());
    try {
      await _sizeRepository.initializeSizes(event.sizes);
      emit(SizeInitialized());
    } catch (e) {
      emit(SizeError(e.toString()));
    }
  }
}