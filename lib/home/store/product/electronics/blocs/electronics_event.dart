import 'package:equatable/equatable.dart';
import 'package:my_example_file/home/store/product/electronics/models/electronic_model.dart';

abstract class ElectronicsEvent extends Equatable {
  const ElectronicsEvent();

  @override
  List<Object> get props => [];
}

class GetElectronics extends ElectronicsEvent {
  final String type;
  const GetElectronics(this.type);

  @override
  List<Object> get props => [type];
}

class GetElectronicDetails extends ElectronicsEvent {
  final String id;
  const GetElectronicDetails(this.id);

  @override
  List<Object> get props => [id];
}

class UpdateElectronic extends ElectronicsEvent {
  final ElectronicsModel electronic;
  const UpdateElectronic(this.electronic);

  @override
  List<Object> get props => [electronic];
}

class GetOperatingSystems extends ElectronicsEvent {}

class AddProductToOS extends ElectronicsEvent {
  final String productId;
  final String osId;
  const AddProductToOS(this.productId, this.osId);

  @override
  List<Object> get props => [productId, osId];
}
