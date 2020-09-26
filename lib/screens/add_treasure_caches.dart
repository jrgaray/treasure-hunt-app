import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:treasure_hunt/models/treasure_cache.dart';
import 'package:treasure_hunt/models/treasure_hunt.dart';
import 'package:treasure_hunt/screens/edit_treasure_chart.dart';
import 'package:treasure_hunt/screens/root.dart';
import 'package:treasure_hunt/state/treasure_chart_state.dart';
import 'package:uuid/uuid.dart';
import '../utils/checkLocationService.dart';
import '../components/dialog.dart';
import 'package:provider/provider.dart';

class AddTreasureCaches extends HookWidget {
  static const routeName = 'newCache';

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context).settings.arguments;
    int chartIndex = args['index'];
    TreasureHunt chart = args['chart'];
    // Declare location and state objects needed.
    final Location location = new Location();
    context.watch<TreasureChartState>();

    /// Event listener for when a marker is dragged. Updates the state of the
    /// treasure hunt as well as google maps.
    LatLng _onDragEnd(LatLng value, String cacheId) {
      chart.treasureCache.firstWhere((cache) => cache.id == cacheId).location =
          value;
      context.read<TreasureChartState>().updateTreasureChart(chartIndex, chart);
      return value;
    }

    /// Event listener for when a marker is dragged. Updates the state of the
    /// treasure hunt as well as google maps.
    LatLng _onMarkerDrag(
        BuildContext context, LatLng value, String chartId, String cacheId) {
      chart.treasureCache.firstWhere((cache) => cache.id == cacheId).location =
          value;
      context.read<TreasureChartState>().updateTreasureChart(chartIndex, chart);
      return value;
    }

    /// Event listerer for when the marker dragged. Removes a marker when tapped.
    void _onTap(String cacheId) => context
        .read<TreasureChartState>()
        .removeTreasureCache(chart.id, cacheId);

    /// Event listerer for when the marker dragged. Removes a marker when tapped.
    void _onMarkerTap(BuildContext context, String chartId, String cacheId) =>
        context
            .read<TreasureChartState>()
            .removeTreasureCache(chartId, cacheId);

    /// Event listener for then the map is tapped. Added a cache marker to the map.
    void _onMapTap(LatLng location) {
      final cacheId = new Uuid().v4();
      chart.addTreasureCache(
        new TreasureCache(
            groupId: chart.id,
            id: cacheId,
            location: location,
            onTap: _onMarkerTap,
            onDrag: (context) =>
                (value) => _onMarkerDrag(context, value, chart.id, cacheId)),
      );
      context.read<TreasureChartState>().updateTreasureChart(chartIndex, chart);
    }

    /// Opens a dialog for the user to commit to their changes and add clues.
    void _openNextDialog() async {
      await dialog(context, title: 'Done adding caches?', dialogOptions: [
        SimpleDialogOption(
          onPressed: () {
            Navigator.popUntil(
                context, ModalRoute.withName(RootScreen.routeName));
            Navigator.pushNamed(context, EditTreasureChart.routeName,
                arguments: chartIndex);
          },
          child: Text('Yes'),
        ),
        SimpleDialogOption(
          onPressed: () => Navigator.pop(context),
          child: Text('No'),
        ),
      ]);
    }

    /// Ensures the done floating action button only displays when a user has
    /// added a marker.
    Widget _shouldDisplayFab() {
      return chart.treasureCache.length > 0
          ? FloatingActionButton(
              isExtended: true,
              child: Icon(
                Icons.done,
              ),
              onPressed: _openNextDialog,
            )
          : null;
    }

    /// Creates the markers for google maps from the treasure cache data.
    Set<Marker> createMarkers() {
      return chart.treasureCache.asMap().entries.map((entry) {
        final cache = entry.value;
        final color = chart.treasureCache.length - 1 == entry.key
            ? BitmapDescriptor.hueRed
            : BitmapDescriptor.hueAzure;
        return Marker(
          markerId: MarkerId(cache.id),
          position: cache.location,
          consumeTapEvents: true,
          onTap: () => _onTap(cache.id),
          // onTap: () => cache.onTap(context, chart.id, cache.id),
          icon: BitmapDescriptor.defaultMarkerWithHue(color),
          draggable: true,
          onDragEnd: (value) => _onDragEnd(value, cache.id),
        );
      }).toSet();
    }

    /// Creates the polyline that connects all the markers from the treasure
    /// cache data.
    Set<Polyline> createPolyline() => [
          Polyline(
              polylineId: PolylineId('rolypoly'),
              jointType: JointType.round,
              points: chart.treasureCache
                  .map((TreasureCache cache) => cache.location)
                  .toList())
        ].toSet();

    return FutureBuilder(
      future: checkLocationService(location),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Scaffold(
            appBar: AppBar(
              title: Text('Add Caches'),
              automaticallyImplyLeading: false,
            ),
            body: GoogleMap(
              markers: createMarkers(),
              mapToolbarEnabled: false,
              onTap: _onMapTap,
              mapType: MapType.satellite,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              polylines: createPolyline(),
              initialCameraPosition: CameraPosition(
                target: chart.treasureCache.length > 0
                    ? chart.treasureCache.last.location
                    : LatLng(snapshot.data.latitude, snapshot.data.longitude),
                zoom: 17,
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: _shouldDisplayFab());
      },
    );
  }
}
