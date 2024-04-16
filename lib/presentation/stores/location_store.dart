import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../../commons/commons.dart';
import '../../data/data.dart';

class LocationStore {
  static const allowedPermissions = [
    LocationPermission.whileInUse,
    LocationPermission.always,
  ];

  final ILocationRepository locationRepository;
  final ValueNotifier<bool> isLoading = ValueNotifier<bool>(false);
  final ValueNotifier<LatLng?> currentPosition = ValueNotifier<LatLng?>(null);
  final ValueNotifier<Location?> locationState = ValueNotifier<Location?>(null);
  final ValueNotifier<String> error = ValueNotifier<String>('');

  LocationStore({required this.locationRepository});

  Future<void> getLocationFromApi(String ip) async {
    isLoading.value = true;
    try {
      final location = await locationRepository.getLocation(ip);

      currentPosition.value = LatLng(location.lat, location.lon);
    } on NotFoundException catch (e) {
      error.value = e.messege;
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> canAccessLocation() async {
    final permission = await Geolocator.checkPermission();
    return allowedPermissions.contains(permission);
  }

  Future<bool> requestPermission({bool toggleChecked = true, bool initialize = false}) async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever ||
        permission == LocationPermission.unableToDetermine ||
        toggleChecked == false) {
      if (PlatformUtils.isIOS) {
        await Geolocator.openLocationSettings();
      } else {
        AppSettings.openAppSettings();
      }
      return canAccessLocation();
    }
    if (PlatformUtils.isIOS) {
      await Geolocator.requestPermission();
      return canAccessLocation();
    } else {
      final grantedPermission = await Geolocator.requestPermission();
      if (grantedPermission == LocationPermission.deniedForever && initialize == false) {
        if (PlatformUtils.isIOS) {
          await Geolocator.openLocationSettings();
        } else {
          AppSettings.openAppSettings();
        }
      }
      return allowedPermissions.contains(grantedPermission);
    }
  }

  Future<bool> requestPermissionInRuntimeIOS() async {
    if (PlatformUtils.isIOS) {
      await Geolocator.requestPermission();
    }
    return canAccessLocation();
  }

  Future<void> getCoordinates() async {
    try {
      isLoading.value = true;
      final position = await Geolocator.getCurrentPosition();
      currentPosition.value = LatLng(position.latitude, position.longitude);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
