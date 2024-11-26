import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/home/store/bloc/color/color_event.dart';
import 'package:my_example_file/home/store/bloc/color/color_state.dart';
import 'package:my_example_file/home/store/repositories/color_repository.dart';



class ColorBloc extends Bloc<ColorEvent, ColorState> {
  final ColorRepository colorRepository;

  ColorBloc({required this.colorRepository}) : super(ColorInitial()) {
    on<GetColors>(_onGetColors);
    on<InitializeColors>(_onInitializeColors);
    on<GetColorById>(_onGetColorById);
  }

  Future<void> _onGetColors(GetColors event, Emitter<ColorState> emit) async {
    emit(ColorLoading());
    try {
      final colors = await colorRepository.getAllColors();
      emit(ColorLoaded(colors));
    } catch (e) {
      emit(ColorError(e.toString()));
    }
  }

 Future<void> _onInitializeColors(InitializeColors event, Emitter<ColorState> emit) async {
  emit(ColorLoading());
  try {
    await colorRepository.initializeColors(event.colorsByCategory);
    emit(ColorOperationSuccess());
  } catch (e) {
    emit(ColorError(e.toString()));
  }
}
  Future<void> _onGetColorById(GetColorById event, Emitter<ColorState> emit) async {
    emit(ColorLoading());
    try {
      final color = await colorRepository.getColorById(event.colorId);
      if (color != null) {
        emit(SingleColorLoaded(color));
      } else {
        emit(ColorError('Түс табылган жок'));
      }
    } catch (e) {
      emit(ColorError(e.toString()));
    }
  }
}