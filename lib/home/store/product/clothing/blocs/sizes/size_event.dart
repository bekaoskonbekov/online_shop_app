abstract class SizeEvent {}
class GetSizes extends SizeEvent {}

class InitializeSizes extends SizeEvent {
  final List<Map<String, dynamic>> sizes;

  InitializeSizes(this.sizes);
}

