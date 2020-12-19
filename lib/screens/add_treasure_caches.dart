import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:treasure_hunt/models/treasure_hunt.dart';
import 'package:treasure_hunt/screens/edit_treasure_chart.dart';
import 'package:treasure_hunt/screens/root.dart';
import 'package:treasure_hunt/utils/getArgs.dart';
import 'package:treasure_hunt/utils/mapBuilderUtils.dart';
import '../utils/checkLocationService.dart';
import '../components/dialog.dart';

class AddTreasureCaches extends HookWidget {
  static const routeName = 'newCache';

  @override
  Widget build(BuildContext context) {
    ValueNotifier<TreasureHunt> chart = useState(getRouteArgs(context));
    final Location location = new Location();

    /// Opens a dialog for the user to commit to their changes and add clues.
    void _openNextDialog() async {
      await dialog(context, title: 'Done adding caches?', dialogOptions: [
        SimpleDialogOption(
          onPressed: () async {
            await FirebaseFirestore.instance
                .collection('charts')
                .doc(chart.value.id)
                .set(chart.value.toMap());
            Navigator.popUntil(
                context, ModalRoute.withName(RootScreen.routeName));
            Navigator.pushNamed(context, EditTreasureChart.routeName,
                arguments: chart.value);
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
      return chart.value.treasureCache.length > 0
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
        // If the snapshot is pending return a circular progress indicator.
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
              markers: buildMarkers(chart),
              onTap: onMapTap(chart),
              mapType: MapType.normal,
              myLocationButtonEnabled: true,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              polylines: buildPolylines(chart),
              initialCameraPosition: CameraPosition(
                target: setInitialCameraTarget(snapshot, chart),
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
