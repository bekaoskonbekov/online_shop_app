abstract class ColorEvent {}
class GetColors extends ColorEvent {}
class InitializeColors extends ColorEvent {
  final List<Map<String, dynamic>> colorsByCategory;
  InitializeColors(this.colorsByCategory);
}
class GetColorById extends ColorEvent {
  final String colorId;
  GetColorById(this.colorId);
}

