import 'package:my_example_file/home/posts/models/location_model.dart';

class Region {
  final List<LocationModel> locationsList = [
    LocationModel(id: '1', name: 'Бишкек'),
    LocationModel(id: '2', name: 'Ош'),
    LocationModel(id: '3', name: 'Баткенская область', subLocations: [
      SubLocationModel(id: '1.1', name: 'Кадамжай'),
      SubLocationModel(id: '1.2', name: 'Баткен'),
      SubLocationModel(id: '1.3', name: 'Лейлек'),
      SubLocationModel(id: '1.4', name: 'Исфана'),
    ]),
    LocationModel(id: '4', name: 'Джалал-Абадская область',subLocations: [
      SubLocationModel(id: '4.1', name: ' Аксыйский'),
      SubLocationModel(id: '4.2', name: ' Ала-Букинский'),
      SubLocationModel(id: '4.3', name: '  Базар-Коргонский'),
      SubLocationModel(id: '4.4', name: ' Ноокенский'),
      SubLocationModel(id: '4.5', name: ' Сузакский'),
      SubLocationModel(id: '4.6', name: ' Аксыйский'),
      SubLocationModel(id: '4.7', name: ' Тогуз-Тороуский'),
      SubLocationModel(id: '4.8', name: ' Токтогульский'),
      SubLocationModel(id: '4.9', name: 'Чаткальский'),
    ]),
    LocationModel(id: '5', name: 'Иссык-Кульская область',subLocations: [
      SubLocationModel(id: '5.1', name: 'Ак-Суйский'),
      SubLocationModel(id: '5.2', name: 'Джети-Огузский'),
      SubLocationModel(id: '5.3', name: 'Тонский район '),
      SubLocationModel(id: '5.4', name: 'Тюпский район '),
      SubLocationModel(id: '5.5', name: 'Иссык-Кульский'),
      SubLocationModel(id: '5.6', name: ' Каракол'),
      SubLocationModel(id: '5.7', name: 'Балыкчи'),
      SubLocationModel(id: '5.8', name: ' Чолпон-Ата'),
    ]),
    LocationModel(id: '6', name: 'Нарынская область',subLocations: [
      SubLocationModel(id: '6.1', name: 'Ак-Талинский'),
      SubLocationModel(id: '6.2', name: 'Ат-Башинский'),
      SubLocationModel(id: '6.3', name: 'Жумгальский'),
      SubLocationModel(id: '6.4', name: 'Кочкорский район'),
      SubLocationModel(id: '6.5', name: 'Нарынский район'),
    ]),
    LocationModel(id: '7', name: 'Ошская область', subLocations: [
      SubLocationModel(id: '7.1', name: 'Алайский'),
      SubLocationModel(id: '7.2', name: 'Араванский'),
      SubLocationModel(id: '7.3', name: 'Кара-Кульджинский '),
      SubLocationModel(id: '7.4', name: 'Чон-Алайский '),
      SubLocationModel(id: '7.5', name: 'Кара-Сууский'),
      SubLocationModel(id: '7.6', name: 'Ноокатский'),
      SubLocationModel(id: '7.7', name: 'Узгенский'),
    ]),
    LocationModel(id: '8', name: 'Таласская область',subLocations: [
      SubLocationModel(id: '8.1', name: 'Бакай-Атинский'),
      SubLocationModel(id: '8.2', name: 'Кара-Бууринский'),
      SubLocationModel(id: '8.3', name: 'Манасский'),
      SubLocationModel(id: '8.4', name: 'Таласский'),
    ]),
    LocationModel(id: '9', name: 'Чуйская область', subLocations: [
      SubLocationModel(id: '9.1', name: 'Аламудунский'),
      SubLocationModel(id: '9.2', name: 'Жайылский'),
      SubLocationModel(id: '9.3', name: 'Кеминский'),
      SubLocationModel(id: '9.4', name: 'Московский'),
      SubLocationModel(id: '9.5', name: 'Панфиловский'),
      SubLocationModel(id: '9.6', name: 'Сокулукский'),
      SubLocationModel(id: '9.7', name: 'Чуйский'),
      SubLocationModel(id: '9.8', name: 'Ысык-Атинский'),
    ]),
  ];
}

