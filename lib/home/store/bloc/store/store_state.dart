import 'package:equatable/equatable.dart';
import 'package:my_example_file/home/store/models/store_model.dart';

abstract class StoreState extends Equatable {
  const StoreState();

  @override
  List<Object?> get props => [];
}

class StoreInitial extends StoreState {}

class StoreLoading extends StoreState {}

class StoreLoaded extends StoreState {
  final StoreModel store;

  const StoreLoaded(this.store);

  @override
  List<Object?> get props => [store];
}

class StoreError extends StoreState {
  final String message;

  const StoreError(this.message);

  @override
  List<Object?> get props => [message];
}