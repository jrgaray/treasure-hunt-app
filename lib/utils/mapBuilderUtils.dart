import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uuid/uuid.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:treasure_hunt/models/treasure_cache.dart';
import 'package:treasure_hunt/models/treasure_chart.dart';

double colorSelector(entry, List<TreasureCache> caches) =>
    caches.length - 1 == entry.key
        ? BitmapDescriptor.hueRed
        : BitmapDescriptor.hueAzure;

/// Creates the polyline that connects all the markers from the treasure
/// cache data.
Set<Polyline> buildPolylines(List<TreasureCache> caches) => [
      Polyline(
          polylineId: PolylineId('rolypoly'),
          jointType: JointType.round,
          points: caches.map((TreasureCache cache) => cache.location).toList())
    ].toSet();

/// Set the initial position on goolge maps. Either targets the last cache
/// position or your current position.
LatLng setInitialCameraTarget(
        AsyncSnapshot<Position> snapshot, List<TreasureCache> caches) =>
    caches.length > 0
        ? caches.last.location
        : LatLng(snapshot.data.latitude, snapshot.data.longitude);

/// Event listener for when a marker is dragged. Updates the state of the
/// treasure hunt as well as google maps.
LatLng onDragEnd(LatLng value, String cacheId, ValueNotifier chart) {
  chart.value.treasureCache
      .firstWhere((TreasureCache cache) => cache.id == cacheId)
      .location = value;
  chart.value = new TreasureChart.copy(chart.value);
  return value;
}

/// Event listerer for when the marker dragged. Removes a marker when tapped.
void onTap(String cacheId, ValueNotifier chart) {
  chart.value.setTreasureCaches = chart.value.treasureCache
      .where((TreasureCache cache) => cache.id != cacheId)
      .toList();
  chart.value = new TreasureChart.copy(chart.value);
}

/// Creates the markers for google maps from the treasure cache data.
Set<Marker> buildMarkers(ValueNotifier<TreasureChart> chart) {
  return chart.value.treasureCache.asMap().entries.map((entry) {
    final cacheId = entry.value.id;
    return Marker(
      markerId: MarkerId(cacheId),
      position: entry.value.location,
      consumeTapEvents: true,
      onTap: () => onTap(cacheId, chart),
      icon: BitmapDescriptor.defaultMarkerWithHue(
          colorSelector(entry, chart.value.treasureCache)),
      draggable: true,
      onDragEnd: (value) => onDragEnd(value, cacheId, chart),
    );
  }).toSet();
}

Set<Marker> buildStaticMarkers(List<TreasureCache> caches) {
  return caches.asMap().entries.map((entry) {
    final cacheId = entry.value.id;
    return Marker(
      markerId: MarkerId(cacheId),
      position: entry.value.location,
      consumeTapEvents: true,
      icon: BitmapDescriptor.defaultMarkerWithHue(colorSelector(entry, caches)),
    );
  }).toSet();
}

/// Event listener for then the map is tapped. Added a cache marker to the map.
Function(LatLng) onMapTap(ValueNotifier chart) {
  return (LatLng location) {
    chart.value.addTreasureCache(
      new TreasureCache(
        groupId: chart.value.id,
        id: new Uuid().v4(),
        location: location,
      ),
    );
    chart.value = new TreasureChart.copy(chart.value);
  };
}
