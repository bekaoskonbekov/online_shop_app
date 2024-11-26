import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/home/store/product/electronics/blocs/electronics_event.dart';
import 'package:my_example_file/home/store/product/electronics/blocs/electronics_state.dart';
import 'package:my_example_file/home/store/repositories/product_services.dart';

class ElectronicsBloc extends Bloc<ElectronicsEvent, ElectronicsState> {
  final ProductService _productService;

  ElectronicsBloc({required ProductService productService})
      : _productService = productService,
        super(ElectronicsInitial()) {
    on<GetElectronics>(_onGetElectronics);
    on<GetElectronicDetails>(_onGetElectronicDetails);
    on<UpdateElectronic>(_onUpdateElectronic);
    on<GetOperatingSystems>(_onGetOperatingSystems);
    on<AddProductToOS>(_onAddProductToOS);
  }

  Future<void> _onGetElectronics(GetElectronics event, Emitter<ElectronicsState> emit) async {
    emit(ElectronicsLoading());
    try {
      final electronics = await _productService.getElectronicsByType(event.type);
      emit(ElectronicsLoaded(electronics));
    } catch (e) {
      emit(ElectronicsError(e.toString()));
    }
  }

  Future<void> _onGetElectronicDetails(GetElectronicDetails event, Emitter<ElectronicsState> emit) async {
    emit(ElectronicsLoading());
    try {
      final electronic = await _productService.getElectronicsById(event.id);
      if (electronic != null) {
        emit(ElectronicDetailsLoaded(electronic));
      } else {
        emit(ElectronicsError('Электроника табылган жок'));
      }
    } catch (e) {
      emit(ElectronicsError(e.toString()));
    }
  }

  Future<void> _onUpdateElectronic(UpdateElectronic event, Emitter<ElectronicsState> emit) async {
    emit(ElectronicsLoading());
    try {
      await _productService.updateProduct(event.electronic);
      emit(ElectronicDetailsLoaded(event.electronic));
    } catch (e) {
      emit(ElectronicsError(e.toString()));
    }
  }

  Future<void> _onGetOperatingSystems(GetOperatingSystems event, Emitter<ElectronicsState> emit) async {
    emit(ElectronicsLoading());
    try {
      final operatingSystems = await _productService.getAllOSGroupedByProductType();
      emit(OperatingSystemsLoaded(operatingSystems));
    } catch (e) {
      emit(ElectronicsError(e.toString()));
    }
  }

   Future<void> _onAddProductToOS(AddProductToOS event, Emitter<ElectronicsState> emit) async {
    emit(ElectronicsLoading());
    try {
      await _productService.addProductToOS(event.productId, event.osId);
      emit(ProductAddedToOS());
    } catch (e) {
      emit(ElectronicsError(e.toString()));
    }
  }
}
