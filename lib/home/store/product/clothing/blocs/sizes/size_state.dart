// States
import 'package:my_example_file/home/store/product/clothing/models/size_model.dart';

abstract class SizeState {}

class SizeInitial extends SizeState {}

class SizeLoading extends SizeState {}

class SizesLoaded extends SizeState {
  final List<SizeModel> sizes;

  SizesLoaded(this.sizes);
}

class SingleSizeLoaded extends SizeState {
  final SizeModel size;

  SingleSizeLoaded(this.size);
}

class SizeInitialized extends SizeState {}

class SizeError extends SizeState {
  final String message;

  SizeError(this.message);
}

// Bloc
