import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:treasure_hunt/models/treasure_cache.dart';
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
    // Declare location and state objects needed.
    final Location location = new Location();
    final state = context.select((TreasureChartState state) => ({
          'markers': state.treasureCharts.last.markers,
          'polyline': state.treasureCharts.last.polylines
        }));
    final _markers = state['markers'], _polylines = state['polyline'];

    /// Event listener for when a marker is dragged. Updates the state of the
    /// treasure hunt as well as google maps.
    LatLng _onMarkerDrag(LatLng value, String chartId, String cacheId) {
      final huntInfo =
          context.read<TreasureChartState>().retrieveHuntInfo(chartId);
      final chart = huntInfo['treasureHunt'], index = huntInfo['indexOfHunt'];
      chart.treasureCache.firstWhere((cache) => cache.id == cacheId).location =
          value;
      context.read<TreasureChartState>().updateTreasureChart(index, chart);
      return value;
    }

    /// Event listerer for when the marker dragged. Removes a marker when tapped.
    void _onMarkerTap(String chartId, String cacheId) => context
        .read<TreasureChartState>()
        .removeTreasureCache(chartId, cacheId);

    /// Event listener for then the map is tapped. Added a cache marker to the map.
    void _onMapTap(LatLng location) {
      final chartId = context.read<TreasureChartState>().treasureCharts.last.id;
      final cacheId = new Uuid().v4();
      final huntInfo =
          context.read<TreasureChartState>().retrieveHuntInfo(chartId);
      final hunt = huntInfo['treasureHunt'], index = huntInfo['indexOfHunt'];
      hunt.addTreasureCache(
        new TreasureCache(
            groupId: chartId,
            id: cacheId,
            location: location,
            onTap: _onMarkerTap,
            onDrag: (value) => _onMarkerDrag(value, chartId, cacheId)),
      );
      context.read<TreasureChartState>().updateTreasureChart(index, hunt);
    }

    /// Opens a dialog for the user to commit to their changes and add clues.
    void _openNextDialog() async {
      await dialog(context, title: 'Done adding caches?', dialogOptions: [
        SimpleDialogOption(
          onPressed: () {
            Navigator.popUntil(
                context, ModalRoute.withName(RootScreen.routeName));
            final index =
                context.read<TreasureChartState>().treasureCharts.length - 1;
            Navigator.pushNamed(context, EditTreasureChart.routeName,
                arguments: index);
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
      return _markers.length > 0
          ? FloatingActionButton(
              isExtended: true,
              child: Icon(
                Icons.done,
              ),
              onPressed: _openNextDialog,
            )
          : null;
    }

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
              markers: _markers.toSet(),
              mapToolbarEnabled: false,
              onTap: _onMapTap,
              mapType: MapType.satellite,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              polylines: _polylines.toSet(),
              initialCameraPosition: CameraPosition(
                target: LatLng(snapshot.data.latitude, snapshot.data.longitude),
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
