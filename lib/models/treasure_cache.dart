import 'package:google_maps_flutter/google_maps_flutter.dart';

class TreasureCache {
  String id;
  String groupId;
  String clue;
  LatLng location;
  Function onDrag;
  Function onTap;
  TreasureCache({
    this.id,
    this.groupId,
    this.clue,
    this.location,
    this.onDrag,
    this.onTap,
  });
}
