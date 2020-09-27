import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:treasure_hunt/models/treasure_cache.dart';
import 'package:treasure_hunt/models/user.dart';

import './treasure_hunt.dart';

class TreasureHuntDTO {
  Map<String, dynamic> convertToMap(TreasureHunt hunt) {
    return {
      'title': hunt.title,
      'creator': {
        'firstName': hunt.creator.firstName,
        'lastName': hunt.creator.lastName,
        'avatarURL': hunt.creator.avatarUrl,
        'icon': hunt.creator.icon,
        'birthday': hunt.creator.birthday
      },
      'description': hunt.description,
      'startDate': hunt.startDate,
      'isPublished': hunt.isPublished,
      'treasureCaches': hunt.treasureCache
          .map((TreasureCache cache) => {
                'id': cache.id,
                'groupId': cache.groupId,
                'clue': cache.clue,
                'location': GeoPoint(
                  cache.location.latitude,
                  cache.location.longitude,
                )
              })
          .toList()
    };
  }

  User convertFirebaseToUser(data) {
    return User(
      firstName: data['firstName'],
      lastName: data['lastName'],
      birthday: data['birthday'].toDate(),
      url: data['avatarURL'],
      icon: data['icon'],
    );
  }

  List convertToTreasureHunt(List<QueryDocumentSnapshot> data) {
    return data.map((doc) {
      final rawHunt = doc.data();
      return TreasureHunt(
        creator: convertFirebaseToUser(rawHunt['creator']),
      );
    }).toList();
  }
}
