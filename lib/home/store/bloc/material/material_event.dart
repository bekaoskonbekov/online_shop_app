import 'package:equatable/equatable.dart';
abstract class MaterialEvent extends Equatable {
  const MaterialEvent();
  @override
  List<Object?> get props => [];
}
class GetMaterials extends MaterialEvent {}
class GetMaterialsByCategory extends MaterialEvent {
  final String categoryType;
  const GetMaterialsByCategory({required this.categoryType});
  @override
  List<Object> get props => [categoryType];
}
class InitializeMaterials extends MaterialEvent {
  final Map<String, List<String>> materialsByCategory;

  const InitializeMaterials({required this.materialsByCategory});

  @override
  List<Object?> get props => [materialsByCategory];
}