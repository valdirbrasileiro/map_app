import 'package:map_app_flutter/data/repositories/connection_repository.dart';
import 'package:map_app_flutter/presentation/stores/connection_store.dart';

import '../data/data.dart';
import '../presentation/stores/stores.dart';

class DependencyContainer {
  static final DependencyContainer _instance = DependencyContainer._internal();

  factory DependencyContainer() {
    return _instance;
  }

  DependencyContainer._internal();

  // Instâncias que você quer utilizar em seu projeto
  // final LocationService locationService = LocationService();
  final ConnectionStore connectionStore = ConnectionStore(
      connectionRepository: ConnectionRepository(client: HttpClient()));
  final LocationStore locationStore = LocationStore(
      locationRepository: LocationReposotory(client: HttpClient()));
}
