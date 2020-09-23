import 'dart:core';
import 'dart:async';
import 'package:location/location.dart';

bool _serviceEnabled;
PermissionStatus _permissionGranted;

/// Check if there was permission granted and if service was enabled.
Future checkLocationService(Location location) async {
  _serviceEnabled = await location.serviceEnabled();

  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return;
    }
  }
  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return;
    }
  }

  return location.getLocation();
}
