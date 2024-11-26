import 'package:equatable/equatable.dart';
import 'package:my_example_file/home/store/product/clothing/models/clothing_model.dart';

abstract class ClothingEvent extends Equatable {
  const ClothingEvent();

  @override
  List<Object> get props => [];
}

class LoadClothings extends ClothingEvent {}

class LoadClothingById extends ClothingEvent {
  final String clothingId;

  const LoadClothingById(this.clothingId);

  @override
  List<Object> get props => [clothingId];
}

class CreateClothing extends ClothingEvent {
  final ClothingModel clothing;

  const CreateClothing(this.clothing);

  @override
  List<Object> get props => [clothing];
}

class UpdateClothing extends ClothingEvent {
  final ClothingModel clothing;

  const UpdateClothing(this.clothing);

  @override
  List<Object> get props => [clothing];
}

class DeleteClothing extends ClothingEvent {
  final String clothingId;

  const DeleteClothing(this.clothingId);

  @override
  List<Object> get props => [clothingId];
}