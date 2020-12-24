import 'dart:core';
import 'dart:async';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:treasure_hunt/models/treasure_hunt.dart';

/// Check if there was permission granted and if service was enabled.
Future<bool> checkLocationServiceAndPermission() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permantly denied, we cannot request permissions.');
  }

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return Future.error(
          'Location permissions are denied (actual value: $permission).');
    }
  }
  return true;
}

Future<Position> getLocation() async {
  try {
    return await checkLocationServiceAndPermission()
        ? Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        : null;
  } catch (error) {
    print(error);
    return null;
  }
}

LatLng getLatLngLocation(Position position) =>
    new LatLng(position.latitude, position.longitude);

double getDistanceBetween(TreasureHunt hunt, Position currentLocation) {
  final nextCache = hunt.treasureCache[hunt.currentCacheIndex + 1];
  final cacheLocation = nextCache.location;
  return Geolocator.distanceBetween(
      currentLocation.latitude,
      currentLocation.longitude,
      cacheLocation.latitude,
      cacheLocation.longitude);
}
