// States
import 'package:equatable/equatable.dart';
import 'package:my_example_file/home/store/product/electronics/models/OS_model.dart';
import 'package:my_example_file/home/store/product/electronics/models/electronic_model.dart';

abstract class ElectronicsState extends Equatable {
  const ElectronicsState();
  
  @override
  List<Object> get props => [];
}

class ElectronicsInitial extends ElectronicsState {}

class ElectronicsLoading extends ElectronicsState {}

class ElectronicsLoaded extends ElectronicsState {
  final List<ElectronicsModel> electronics;
  const ElectronicsLoaded(this.electronics);

  @override
  List<Object> get props => [electronics];
}

class ElectronicDetailsLoaded extends ElectronicsState {
  final ElectronicsModel electronic;
  const ElectronicDetailsLoaded(this.electronic);

  @override
  List<Object> get props => [electronic];
}

class OperatingSystemsLoaded extends ElectronicsState {
  final Map<String, List<OperatingSystemModel>> operatingSystems;
  const OperatingSystemsLoaded(this.operatingSystems);

  @override
  List<Object> get props => [operatingSystems];
}

class ProductAddedToOS extends ElectronicsState {}

class ElectronicsError extends ElectronicsState {
  final String message;
  const ElectronicsError(this.message);

  @override
  List<Object> get props => [message];
}