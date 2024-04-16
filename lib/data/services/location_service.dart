import 'package:geolocator/geolocator.dart';
import 'package:app_settings/app_settings.dart';

import '../../commons/commons.dart';
import '../data.dart';


class LocationService {
 static const allowedPermissions = [
   LocationPermission.whileInUse,
   LocationPermission.always,
 ];


 Future<bool> canAccessLocation() async {
   final permission = await Geolocator.checkPermission();
   return allowedPermissions.contains(permission);
 }


 Future<bool> requestPermission({bool toggleChecked = true}) async {
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
     return allowedPermissions.contains(grantedPermission);
   }
 }


 Future<bool> requestPermissionInRuntimeIOS() async {
   if (PlatformUtils.isIOS) {
     await Geolocator.requestPermission();
   }
   return canAccessLocation();
 }


 Future<Coordinates> getCoordinates() async {
   final currentPosition = await Geolocator.getCurrentPosition();
   return Coordinates(
     latitude: currentPosition.latitude,
     longitude: currentPosition.longitude,
   );
 }
}
