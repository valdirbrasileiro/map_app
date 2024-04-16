import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:map_app_flutter/data/data.dart';
import 'package:map_app_flutter/data/repositories/connection_repository.dart';

class ConnectionStore {
  final IConnectionRepository connectionRepository;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<String> error = ValueNotifier<String>('');

  ConnectionStore({required this.connectionRepository});

  Future<bool> checkConnectivity() async {
    bool isConnected = false;
    try {
      isLoading.value = true;
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult.contains(ConnectivityResult.none)) {
        throw NotFoundConnection('Nenhuma conexão de rede disponível');
      }

      if (connectivityResult.contains(ConnectivityResult.mobile) ||
          connectivityResult.contains(ConnectivityResult.wifi)) {
        isConnected = true;
      }

      return isConnected;
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> getIp() async {
    try {
      isLoading.value = true;
      final ip = await connectionRepository.getIp();
      return ip;
    } on NotFoundException catch (e) {
      error.value = e.messege;
      return '';
    } catch (e) {
      error.value = e.toString();
      return '';
    } finally {
      isLoading.value = false;
    }
  }
}
