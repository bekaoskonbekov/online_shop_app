import 'package:my_example_file/home/store/product/electronics/models/OS_model.dart';
abstract class OSState {
  const OSState();
}
class OSInitial extends OSState {}
class OSLoading extends OSState {}
class OSLoaded extends OSState {
  final List<OperatingSystemModel> osList;
  const OSLoaded(this.osList);
}
class OSGroupedLoaded extends OSState {
  final Map<String, List<OperatingSystemModel>> osMap;
  const OSGroupedLoaded(this.osMap);
}
class OSCreated extends OSState {
  final OperatingSystemModel operatingSystemModel;
  const OSCreated(this.operatingSystemModel);
}
class OSInitialized extends OSState {
  const OSInitialized();
}
class OSError extends OSState {
  final String message;
  const OSError(this.message);
}