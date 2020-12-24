// import 'dart:core';
// import 'dart:async';
import 'package:location/location.dart';

/// Check if there was permission granted and if service was enabled.
Future<bool> checkLocationServiceAndPermission(Location location) async {
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  _serviceEnabled = await location.serviceEnabled();

  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return false;
    }
  }
  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return false;
    }
  }
  return true;
}

Future<LocationData> getLocation(Location location) async =>
    await checkLocationServiceAndPermission(location)
        ? location.getLocation()
        : null;
