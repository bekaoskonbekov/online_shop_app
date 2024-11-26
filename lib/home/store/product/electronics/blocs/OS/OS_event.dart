abstract class OSEvent {}
class LoadAllOS extends OSEvent {}
class LoadGroupedOS extends OSEvent {}
class InitializeOS extends OSEvent {
  final Map<String, List<Map<String, dynamic>>> osList;
  InitializeOS(this.osList);
}