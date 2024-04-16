import 'dart:convert';
import '../data.dart';

abstract class IConnectionRepository {
  Future<String> getIp();
}

class ConnectionRepository implements IConnectionRepository {
  final IHttpClient client;

  ConnectionRepository({required this.client});
  @override
  Future<String> getIp() async {
    var response = await client.get(url: 'https://api.ipify.org?format=json');
    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      return jsonResponse['ip'];
    } else if (response.statusCode == 404) {
      throw NotFoundException('Requisição inválida');
    } else {
      throw Exception('Não foi possível carregar localização');
    }
  }
}
