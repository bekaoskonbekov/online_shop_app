import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/home/store/bloc/material/material_event.dart';
import 'package:my_example_file/home/store/bloc/material/material_state.dart';
import 'package:my_example_file/home/store/repositories/material_repository.dart';
class MaterialBloc extends Bloc<MaterialEvent, MaterialState> {
  final MaterialRepository _materialRepository;

  MaterialBloc({required MaterialRepository materialRepository})
      : _materialRepository = materialRepository,
        super(MaterialInitial()) {
    on<GetMaterials>(_onGetMaterials);
    on<GetMaterialsByCategory>(_onGetMaterialsByCategory);
    on<InitializeMaterials>(_onInitializeMaterials);
  }

  Future<void> _onGetMaterials(GetMaterials event, Emitter<MaterialState> emit) async {
    emit(MaterialLoading());
    try {
      final materials = await _materialRepository.getAllMaterials();
      emit(MaterialLoaded(materials));
    } catch (e) {
      emit(MaterialError(e.toString()));
    }
  }

  Future<void> _onGetMaterialsByCategory(GetMaterialsByCategory event, Emitter<MaterialState> emit) async {
    emit(MaterialLoading());
    try {
      final materials = await _materialRepository.getMaterialsByCategory(event.categoryType);
      emit(MaterialLoaded(materials));
    } catch (e) {
      emit(MaterialError(e.toString()));
    }
  }

  Future<void> _onInitializeMaterials(InitializeMaterials event, Emitter<MaterialState> emit) async {
    emit(MaterialLoading());
    try {
      await _materialRepository.initializeMaterials(event.materialsByCategory);
      emit(MaterialInitialized());
    } catch (e) {
      emit(MaterialError(e.toString()));
    }
  }
}