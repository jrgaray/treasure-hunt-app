import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:treasure_hunt/models/treasure_hunt.dart';
import 'package:treasure_hunt/utils/location_helpers.dart';
import 'package:treasure_hunt/utils/getArgs.dart';
import 'package:treasure_hunt/utils/mapBuilderUtils.dart';

class ViewTreasureHuntMap extends HookWidget {
  const ViewTreasureHuntMap({Key key}) : super(key: key);
  static const title = Text("View Treasure Hunt Caches");
  static const routeName = "viewTreasureHuntMap";

  @override
  Widget build(BuildContext context) {
    final Location location = new Location();
    final TreasureHunt hunt = getRouteArgs(context);
    return FutureBuilder(
      future: checkLocationServiceAndPermission(location),
      builder: (context, snapshot) {
        // If the snapshot is pending return a circular progress indicator.
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasError) {
          return const Center(
            child: Text('Oops, I fucked up.'),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Add Caches'),
            automaticallyImplyLeading: false,
          ),
          body: GoogleMap(
            markers: buildStaticMarkers(hunt.foundCaches),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            polylines: buildPolylines(hunt.foundCaches),
            initialCameraPosition: CameraPosition(
              target: setInitialCameraTarget(snapshot, hunt.foundCaches),
              zoom: 17,
            ),
          ),
        );
      },
    );
  }
}
