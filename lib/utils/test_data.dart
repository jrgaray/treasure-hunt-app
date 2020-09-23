import 'package:treasure_hunt/models/treasure_hunt.dart';
import 'package:treasure_hunt/models/user.dart';

// Throw away test data. Need to change to pull information from firestore.
final List<TreasureHunt> newTreasureHunts = [
  new TreasureHunt(
    title: "Jose's Treasure Hunt",
    creator: new User(
      firstName: 'Jose',
      lastName: 'Morris-Garay',
      url:
          'https://cdn.mos.cms.futurecdn.net/JycrJzD5tvbGHWgjtPrRZY-1200-80.jpg',
      icon: 'ac_unit',
      birthday: new DateTime(1990, 4, 15),
    ),
    description: 'A present to my goose.',
    start: DateTime.now(),
    end: DateTime.now().add(new Duration(days: 30)),
  ),
  new TreasureHunt(
    title: "Anne's Treasure Hunt",
    creator: new User(
      firstName: 'Anne',
      lastName: 'Morris-Garay',
      url:
          'https://cdn.mos.cms.futurecdn.net/JycrJzD5tvbGHWgjtPrRZY-1200-80.jpg',
      icon: 'ac_unit',
      birthday: new DateTime(1990, 4, 11),
    ),
    description: 'A present to my bear.',
    start: DateTime.now(),
    end: DateTime.now().add(new Duration(days: 30)),
  )
];
