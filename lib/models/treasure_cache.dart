import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TreasureCache {
  String id;
  String groupId;
  String clue;
  LatLng location;
  TreasureCache({
    this.id,
    this.groupId,
    this.clue,
    this.location,
  });
  Map<String, dynamic> toFirebaseObject() => {
        "id": id,
        "groupId": groupId,
        "clue": clue,
        "location": GeoPoint(location.latitude, location.longitude)
      };
}
