import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:treasure_hunt/models/treasure_hunt.dart';
import 'package:treasure_hunt/screens/view_treasure_hunt_map.dart';
import 'package:treasure_hunt/utils/location_helpers.dart';
import 'package:treasure_hunt/utils/getArgs.dart';

class TreasureHuntStatus extends HookWidget {
  const TreasureHuntStatus({Key key}) : super(key: key);
  static const title = Text("Treasure Hunt Status");
  static const routeName = "huntStatus";

  @override
  Widget build(BuildContext context) {
    final Location location = new Location();
    final TreasureHunt hunt = getRouteArgs(context);

    // Future builder to check app permission to get location/stream location.
    return FutureBuilder(
      future: checkLocationServiceAndPermission(location),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        // Stream builder to stream location for finding treasure caches.
        return StreamBuilder(
          stream: location.onLocationChanged,
          builder: (context, snapshot) {
            // If the snapshot is pending return a circular progress indicator.
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final LocationData loData = snapshot.data;
            // Use Latlong for calculation.
            print(hunt.currentCache.location);

            return Scaffold(
              appBar: AppBar(
                title: title,
                actions: [
                  IconButton(
                    icon: Icon(Icons.map),
                    onPressed: () => Navigator.pushNamed(
                      context,
                      ViewTreasureHuntMap.routeName,
                      arguments: hunt,
                    ),
                  )
                ],
              ),
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${hunt.title}',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize:
                                    MediaQuery.of(context).size.height / 20),
                          ),
                          Text(
                            "Initial Clue:",
                            style: TextStyle(
                                fontSize:
                                    MediaQuery.of(context).size.height / 30),
                          ),
                          Flexible(
                            child: SingleChildScrollView(
                              child: Text(
                                "${hunt.currentClue}",
                                style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.height /
                                            40),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                      child: Text(
                          "Current Location: ${loData.latitude}, ${loData.longitude}")),
                  Flexible(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 2),
                        ),
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.blueGrey, Colors.transparent]),
                      ),
                      child: ListView.builder(
                        itemCount: hunt.foundCaches.length,
                        itemBuilder: (context, index) {
                          String subtitleSelector() =>
                              hunt.foundCaches.length == 0 ||
                                      hunt.foundCaches[index].clue != null
                                  ? hunt.foundCaches[index].clue
                                  : 'Needs a clue!';
                          return Container(
                            child: ListTile(
                              // onTap: () => onTap(index),
                              // onLongPress: () => onLongPress(index),
                              subtitle: Text(subtitleSelector()),
                              title: Text(
                                  'Latitude: ${hunt.foundCaches[index].location.latitude},\nLongitude: ${hunt.foundCaches[index].location.longitude}'),
                              leading: CircleAvatar(
                                backgroundColor: Colors.indigo,
                                child: Text('${index + 1}'),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
