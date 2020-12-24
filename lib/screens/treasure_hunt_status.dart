import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:treasure_hunt/firebase/store.dart';
import 'package:treasure_hunt/models/treasure_hunt.dart';
import 'package:treasure_hunt/screens/view_treasure_hunt_map.dart';
import 'package:treasure_hunt/utils/location_helpers.dart';
import 'package:treasure_hunt/utils/getArgs.dart';
import 'package:provider/provider.dart';

class TreasureHuntWin extends HookWidget {
  const TreasureHuntWin({Key key, this.hunt}) : super(key: key);
  final TreasureHunt hunt;
  @override
  Widget build(BuildContext context) {
    return Column(
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
                      fontSize: MediaQuery.of(context).size.height / 20),
                ),
                Text("you found the treasure!"),
              ],
            ),
          ),
        ),
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 2),
              ),
            ),
            child: ListView.builder(
              itemCount: hunt.foundCaches.length,
              itemBuilder: (context, index) {
                String subtitleSelector() => hunt.foundCaches.length == 0 ||
                        hunt.foundCaches[index].clue != null
                    ? hunt.foundCaches[index].clue
                    : 'Needs a clue!';
                return Container(
                  child: ListTile(
                    subtitle: Text(subtitleSelector()),
                    title: Text(
                        'Latitude: ${hunt.foundCaches[index].location.latitude.truncateToDouble()},\nLongitude: ${hunt.foundCaches[index].location.longitude.truncateToDouble()}'),
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
    );
  }
}

class TreasureHuntStatusContent extends HookWidget {
  const TreasureHuntStatusContent({Key key, this.hunt, this.currentLocation})
      : super(key: key);
  final TreasureHunt hunt;
  final Position currentLocation;
  @override
  Widget build(BuildContext context) {
    final User user = context.watch<User>();
    final distanceToNextCache = getDistanceBetween(hunt, currentLocation);
    useEffect(() {
      if (distanceToNextCache < 10.0) {
        Future.microtask(() async => await updateTreasureHunt(user.uid, hunt));
      }
      return;
    }, [user.uid, hunt, distanceToNextCache]);

    return Column(
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
                      fontSize: MediaQuery.of(context).size.height / 20),
                ),
                Text(
                  "CurrentClue:",
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.height / 30),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Text(
                      "${hunt.currentClue}",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 40),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Flexible(
          child: Text(
              "Distance to next cache: ${distanceToNextCache.truncateToDouble()}m"),
        ),
        Flexible(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 2),
              ),
            ),
            child: ListView.builder(
              itemCount: hunt.foundCaches.length,
              itemBuilder: (context, index) {
                String subtitleSelector() => hunt.foundCaches.length == 0 ||
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
    );
  }
}

class TreasureHuntStatus extends HookWidget {
  const TreasureHuntStatus({Key key}) : super(key: key);
  static const title = Text("Treasure Hunt Status");
  static const routeName = "huntStatus";

  @override
  Widget build(BuildContext context) {
    final TreasureHunt hunt = getRouteArgs(context);

    // Future builder to check app permission to get location/stream location.
    return FutureBuilder(
      future: checkLocationServiceAndPermission(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        // Stream builder to stream location for finding treasure caches.
        return StreamBuilder(
          stream: Geolocator.getPositionStream(),
          builder: (context, AsyncSnapshot<Position> snapshot) {
            // If the snapshot is pending return a circular progress indicator.
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            // If within 10m, unlock next cache by updating hunt to the get cache.
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
                body: hunt.hasWon
                    ? TreasureHuntWin(hunt: hunt)
                    : TreasureHuntStatusContent(
                        hunt: hunt,
                        currentLocation: snapshot.data,
                      ));
          },
        );
      },
    );
  }
}
