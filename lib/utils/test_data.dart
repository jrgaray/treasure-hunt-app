import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:treasure_hunt/models/treasure_cache.dart';
import 'package:treasure_hunt/models/treasure_hunt.dart';
import 'package:treasure_hunt/models/user.dart';
import 'package:uuid/uuid.dart';

final firstId = Uuid().v4();
final secondId = Uuid().v4();

final firstHunt = new TreasureHunt(
  title: "Jose's Treasure Hunt",
  creator: new User(
    firstName: 'Jose',
    lastName: 'Morris-Garay',
    url: 'https://cdn.mos.cms.futurecdn.net/JycrJzD5tvbGHWgjtPrRZY-1200-80.jpg',
    icon: 'ac_unit',
    birthday: new DateTime(1990, 4, 15),
  ),
  description: 'A present to my goose.',
  start: DateTime.now(),
  end: DateTime.now().add(new Duration(days: 30)),
);

final secondHunt = new TreasureHunt(
  title: "Anne's Treasure Hunt",
  creator: new User(
    firstName: 'Anne',
    lastName: 'Morris-Garay',
    url: 'https://cdn.mos.cms.futurecdn.net/JycrJzD5tvbGHWgjtPrRZY-1200-80.jpg',
    icon: 'ac_unit',
    birthday: new DateTime(1990, 4, 11),
  ),
  description: 'A present to my bear.',
  start: DateTime.now(),
  end: DateTime.now().add(new Duration(days: 30)),
);

final cacheOne = new TreasureCache(
  id: Uuid().v4(),
  groupId: firstHunt.id,
  clue: 'hi',
  location: LatLng(1.2, 90.8),
);

final cacheTwo = new TreasureCache(
  id: Uuid().v4(),
  groupId: secondHunt.id,
  clue: 'hi',
  location: LatLng(1.2, 90.8),
);

// Throw away test data. Need to change to pull information from firestore.
List<TreasureHunt> newTreasureHunts() {
  firstHunt.setTreasureCaches = [cacheOne];
  secondHunt.setTreasureCaches = [cacheTwo];
  return [firstHunt, secondHunt];
}
