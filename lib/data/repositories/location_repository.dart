import 'dart:convert';
import '../data.dart';

abstract class ILocationRepository {
  Future<Location> getLocation(String ip);
}

class LocationReposotory implements ILocationRepository {
  final IHttpClient client;

  LocationReposotory({required this.client});
  @override
  Future<Location> getLocation(String ip) async {
    final response = await client.get(url: 'http://ip-api.com/json/$ip');

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final location = Location.fromJson(body);
      return location;
    } else if (response.statusCode == 404) {
      throw NotFoundException('Requisição inválida');
    } else {
      throw Exception('Não foi possível carregar localização');
    }
  }
}
