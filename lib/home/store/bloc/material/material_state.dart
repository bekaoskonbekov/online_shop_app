import 'package:equatable/equatable.dart';
import 'package:my_example_file/home/store/models/material_model.dart';

abstract class MaterialState extends Equatable {
  const MaterialState();

  @override
  List<Object?> get props => [];
}

class MaterialInitial extends MaterialState {}

class MaterialLoading extends MaterialState {}

class MaterialLoaded extends MaterialState {
  final List<MaterialModel> materials;

  const MaterialLoaded(this.materials);

  @override
  List<Object> get props => [materials];
}

class SingleMaterialLoaded extends MaterialState {
  final MaterialModel material;

  const SingleMaterialLoaded(this.material);

  @override
  List<Object> get props => [material];
}

class MaterialError extends MaterialState {
  final String message;

  const MaterialError(this.message);

  @override
  List<Object> get props => [message];
}
class MaterialInitialized extends MaterialState {}