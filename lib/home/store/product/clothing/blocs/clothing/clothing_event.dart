import 'package:equatable/equatable.dart';
import 'package:my_example_file/home/store/product/clothing/models/clothing_model.dart';

abstract class ClothingState extends Equatable {
  const ClothingState();
  
  @override
  List<Object> get props => [];
}

class ClothingInitial extends ClothingState {}

class ClothingLoading extends ClothingState {}

class ClothingsLoaded extends ClothingState {
  final List<ClothingModel> clothings;

  const ClothingsLoaded(this.clothings);

  @override
  List<Object> get props => [clothings];
}

class ClothingLoaded extends ClothingState {
  final ClothingModel clothing;

  const ClothingLoaded(this.clothing);

  @override
  List<Object> get props => [clothing];
}

class ClothingOperationSuccess extends ClothingState {}

class ClothingError extends ClothingState {
  final String message;

  const ClothingError(this.message);

  @override
  List<Object> get props => [message];
}