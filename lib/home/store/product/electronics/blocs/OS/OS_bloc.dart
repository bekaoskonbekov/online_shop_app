import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_example_file/home/store/product/electronics/blocs/OS/OS_event.dart';
import 'package:my_example_file/home/store/product/electronics/blocs/OS/OS_state.dart';
import 'package:my_example_file/home/store/product/electronics/repositories/OS_repository.dart';

class OSBloc extends Bloc<OSEvent, OSState> {
  final OSRepository _osRepository;
  OSBloc({required OSRepository osRepository})
      : _osRepository = osRepository,
        super(OSInitial()) {
    on<LoadAllOS>(_onLoadAllOS);
    on<InitializeOS>(_onInitializeOS);
    on<LoadGroupedOS>(_onLoadGroupedOS);
  }
  Future<void> _onLoadAllOS(LoadAllOS event, Emitter<OSState> emit) async {
    emit(OSLoading());
    try {
      final osList = await _osRepository.getAll();
      emit(osList.isEmpty
          ? const OSError('Операциялык системалар табылган жок')
          : OSLoaded(osList));
    } catch (e) {
      emit(OSError('Операциялык системаларды жүктөөдө ката кетти: $e'));
    }
  }
  Future<void> _onLoadGroupedOS(LoadGroupedOS event, Emitter<OSState> emit) async {
    emit(OSLoading());
    try {
      final osMap = await _osRepository.getAllGroupedByProductType();
      emit(osMap.isEmpty
          ? const OSError('Операциялык системалар табылган жок')
          : OSGroupedLoaded(osMap));
    } catch (e) {
      emit(OSError('Операциялык системаларды топтоштурууда ката кетти: $e'));
    }
  }
  Future<void> _onInitializeOS(InitializeOS event, Emitter<OSState> emit) async {
    emit(OSLoading());
    try {
      await _osRepository.initializeOS(event.osList);
      emit(const OSInitialized());
    } catch (e) {
      emit(OSError('Операциялык системаларды инициализациялоодо ката кетти: $e'));
    }
  }
}