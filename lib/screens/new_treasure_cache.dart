import 'dart:core';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:treasure_hunt/models/treasure_cache.dart';
import 'package:treasure_hunt/state/treasure_chart_state.dart';
import 'package:uuid/uuid.dart';
import '../utils/checkLocationService.dart';
import '../components/dialog.dart';
import 'package:provider/provider.dart';

class NewTreasureCache extends HookWidget {
  static const routeName = 'newCache';

  @override
  Widget build(BuildContext context) {
    final Location location = new Location();
    final state = context.select((TreasureChartState state) => ({
          'markers': state.treasureCharts.last.markers,
          'polyline': state.treasureCharts.last.polylines
        }));
    List<Marker> _markers = state['markers'];
    List<Polyline> _polylines = state['polyline'];

    Map retrieveHuntInfo(chartId, cacheId) {
      // Get the chart state.
      final chartState = context.read<TreasureChartState>();
      // Get the treasureHunt.
      final treasureHunt = chartState.treasureCharts
          .firstWhere((element) => element.id == chartId);

      // Get the index of the treasure hunt.
      final indexOfHunt = chartState.treasureCharts.indexOf(treasureHunt);
      // return [chartState, treasureHunt, indexOfHunt];
      return {
        'treasureHunt': treasureHunt,
        'indexOfHunt': indexOfHunt,
        'chartState': chartState
      };
    }

    void _onMarkerDrag(value, chartId, cacheId) {
      final huntInfo = retrieveHuntInfo(chartId, cacheId);
      final chart = huntInfo['treasureHunt'], index = huntInfo['indexOfHunt'];

      // Updated the chart.
      chart.treasureCache.firstWhere((cache) => cache.id == cacheId).location =
          value;
      // Update state.
      context.read<TreasureChartState>().updateTreasureChart(index, chart);

      return value;
    }

    void _onMarkerTap(chartId, cacheId) => context
        .read<TreasureChartState>()
        .removeTreasureCache(chartId, cacheId);

    void _addLocation({LatLng location, String chartId, String cacheId}) {
      final huntInfo = retrieveHuntInfo(chartId, cacheId);
      final hunt = huntInfo['treasureHunt'],
          state = huntInfo['chartState'],
          index = huntInfo['indexOfHunt'];
      // Add a new cache to the
      hunt.addTreasureCache(
        new TreasureCache(
            groupId: chartId,
            id: cacheId,
            location: location,
            onTap: _onMarkerTap,
            onDrag: (value) => _onMarkerDrag(value, chartId, cacheId)),
      );
      state.updateTreasureChart(index, hunt);
    }

    void _onMapTap(latLing) async {
      final chartId = context.read<TreasureChartState>().treasureCharts.last.id;
      _addLocation(
          location: latLing, chartId: chartId, cacheId: new Uuid().v4());
    }

    void _openNextDialog() async {
      await dialog(context, title: 'Done adding caches?', dialogOptions: [
        SimpleDialogOption(
          onPressed: () => Navigator.pop(context),
          child: Text('Yes'),
        ),
        SimpleDialogOption(
          onPressed: () => Navigator.pop(context),
          child: Text('No'),
        ),
      ]);
    }

    Widget _fabDisplay() {
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
            floatingActionButton: _fabDisplay());
      },
    );
  }
}
