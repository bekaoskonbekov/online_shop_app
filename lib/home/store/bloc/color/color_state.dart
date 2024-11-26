// States
import 'package:equatable/equatable.dart';
import 'package:my_example_file/home/store/models/color_model.dart';

abstract class ColorState  extends Equatable{}

class ColorInitial extends ColorState {
  @override
  List<Object?> get props => [];
}

class ColorLoading extends ColorState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ColorLoaded extends ColorState {
  final List<ColorModel> colors;
  ColorLoaded(this.colors);
  
  @override
  List<Object?> get props => [colors];
}

class SingleColorLoaded extends ColorState {
  final ColorModel color;
  SingleColorLoaded(this.color);
  
  @override
  List<Object?> get props => [color];
}

class ColorOperationSuccess extends ColorState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ColorError extends ColorState {
  final String message;
  ColorError(this.message);
  
  @override
  // TODO: implement props
  List<Object?> get props => [message];
}