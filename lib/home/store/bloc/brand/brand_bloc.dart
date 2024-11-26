// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:my_example_file/home/store/bloc/brand/brand_event.dart';
// import 'package:my_example_file/home/store/bloc/brand/brand_state.dart';
// import 'package:my_example_file/home/store/repositories/brand_repository.dart';
// class BrandBloc extends Bloc<BrandEvent, BrandState> {
//   final BrandRepository _brandRepository;

//   BrandBloc({required BrandRepository brandRepository})
//       : _brandRepository = brandRepository,
//         super(BrandInitial()) {
//     on<GetBrandsByCategory>(_onGetBrandsByCategory);
//     on<InitializeBrands>(_onInitializeBrands);
//   }


//   Future<void> _onGetBrandsByCategory(GetBrandsByCategory event, Emitter<BrandState> emit) async {
//     emit(BrandLoading());
//     try {
//       final brands = await _brandRepository.getBrandsByCategory(event.categoryType);
//       emit(BrandLoaded(brands));
//     } catch (e) {
//       emit(BrandError(e.toString()));
//     }
//   }

//   Future<void> _onInitializeBrands(InitializeBrands event, Emitter<BrandState> emit) async {
//     emit(BrandLoading());
//     try {
//       await _brandRepository.initializeBrands(event.brandsByCategory);
//       emit(BrandInitialized());
//     } catch (e) {
//       emit(BrandError(e.toString()));
//     }
//   }
// }