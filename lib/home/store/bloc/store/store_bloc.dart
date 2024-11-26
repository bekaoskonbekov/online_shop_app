import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/home/store/repositories/store_repository.dart';
import 'store_event.dart';
import 'store_state.dart';

class StoreBloc extends Bloc<StoreEvent, StoreState> {
  final StoreRepository _storeRepository;

  StoreBloc({required StoreRepository storeRepository})
      : _storeRepository = storeRepository,
        super(StoreInitial()) {
    on<CreateStoreEvent>(_onCreateStore);
    // on<UpdateStore>(_onUpdateStore);
    // on<DeleteStore>(_onDeleteStore);
    on<GetStore>(_onGetStore);
    // on<GetStores>(_onGetStores);
    // on<GetPaginatedStores>(_onGetPaginatedStores);
    // on<UpdateStoreRating>(_onUpdateStoreRating);
    // on<ToggleStoreActive>(_onToggleStoreActive);
  }

  Future<void> _onCreateStore(
      CreateStoreEvent event, Emitter<StoreState> emit) async {
    emit(StoreLoading());
    try {
      final newStore = await _storeRepository.createStore(
          userId: event.userId,
          storeBannerUrl: event.storeBannerUrl,
          storeName: event.storeName,
          storeDescription: event.storeDescription,
          contactPhone: event.contactPhone,
          address: event.address,
          businessHours: event.businessHours,
          socialMediaLinks: event.socialMediaLinks);

      if (newStore != null) {
        emit(StoreLoaded(newStore));
      } else {
        emit(StoreError("Failed to create store."));
      }
    } catch (e) {
      emit(StoreError(e.toString()));
    }
  }

Future<void> _onGetStore(
  GetStore event,
  Emitter<StoreState> emit,
) async {
  emit(StoreLoading());
  try {
    final store = await _storeRepository.getStoreByUserId(event.userId);
    if (store != null) {
      emit(StoreLoaded(store));
    } else {
      emit(StoreError('Store not found for this user'));
    }
  } catch (e) {
    emit(StoreError(e.toString()));
  }
}

  // Future<void> _onToggleStoreActive(ToggleStoreActive event, Emitter<StoreState> emit) async {
  //   emit(StoreLoading());
  //   try {
  //     await _storeRepository.toggleStoreActive(event.storeId, event.isActive);
  //     emit(StoreOperationSuccess('Store active status updated successfully'));
  //   } catch (e) {
  //     emit(StoreError(e.toString()));
  //   }
  // }
}
