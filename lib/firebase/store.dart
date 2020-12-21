import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:treasure_hunt/models/treasure_cache.dart';
import 'package:treasure_hunt/models/treasure_hunt.dart';
import 'package:treasure_hunt/models/treasure_search.dart';
import 'package:treasure_hunt/models/treasure_user.dart';

final firestoreInstance = FirebaseFirestore.instance;

final addChart = (Map data) => firestoreInstance.collection("charts").add(data);
void deleteCache(
  TreasureHunt chart,
  TreasureCache cache,
  Function setChart,
) async {
  await firestoreInstance.collection("charts").doc(chart.id).update(
    {
      "treasureCaches": FieldValue.arrayRemove(
        [
          cache.toFirebaseObject(),
        ],
      )
    },
  );
}

void saveClue(String clue, String chartId, int cacheIndex) async {
  final chartDoc =
      await firestoreInstance.collection("charts").doc(chartId).get();
  final chartData = chartDoc.data();
  chartData['treasureCaches'][cacheIndex]['clue'] = clue;
  await firestoreInstance.collection('charts').doc(chartId).update(
    {
      "treasureCaches": chartData["treasureCaches"],
    },
  );
}

List<TreasureSearch> Function(QuerySnapshot) convertToSearch = (snapshot) {
  final docs = snapshot.docs ?? [];
  final data = docs?.map((document) => (document.data()))?.toList();
  return data
      ?.map<TreasureSearch>(
        (firestoreHunt) => new TreasureSearch(
          title: firestoreHunt["title"],
          initialClue: firestoreHunt["initialClue"] ?? "",
          description: firestoreHunt["description"],
          id: firestoreHunt["id"],
          treasureCaches: firestoreHunt["treasureCaches"]?.map<TreasureCache>(
            (cache) {
              return new TreasureCache(
                id: cache["id"],
                groupId: cache["groupId"],
                location: LatLng(
                    cache["location"].latitude, cache["location"].longitude),
                clue: cache["clue"],
              );
            },
          )?.toList(),
        ),
      )
      ?.toList();
};

List<TreasureHunt> Function(QuerySnapshot) convertToHunt =
    (QuerySnapshot snapshot) {
  final docs = snapshot.docs ?? [];
  final data = docs.map((document) => (document.data())).toList();
  return data
      .map<TreasureHunt>(
        (firestoreHunt) => new TreasureHunt(
          title: firestoreHunt["title"],
          initialClue: firestoreHunt["initialClue"] ?? "",
          description: firestoreHunt["description"],
          id: firestoreHunt["id"],
          treasureCaches: firestoreHunt["treasureCaches"].map<TreasureCache>(
            (cache) {
              return new TreasureCache(
                id: cache["id"],
                groupId: cache["groupId"],
                location: LatLng(
                    cache["location"].latitude, cache["location"].longitude),
                clue: cache["clue"],
              );
            },
          ).toList(),
        ),
      )
      .toList();
};
void deleteChart(int index, List<TreasureHunt> charts) async =>
    await firestoreInstance.collection("charts").doc(charts[index].id).delete();

final chartStream =
    () => firestoreInstance.collection("charts").snapshots()?.map(
          (QuerySnapshot snapshot) => convertToHunt(snapshot),
        );

final huntStream = () => firestoreInstance.collection("hunts").snapshots()?.map(
      (QuerySnapshot snapshot) => convertToSearch(snapshot),
    );

Future<void> addUserDataToStore({
  String uid,
  String firstName,
  String lastName,
  DateTime birthday,
  String avatarUrl,
  String email,
}) async {
  await firestoreInstance.collection("user").doc(uid).set(
    {
      "uid": uid,
      "firstName": firstName,
      "lastName": lastName,
      "birthday": birthday,
      "url": avatarUrl ?? "",
      "email": email,
    },
  );
}

Future<TreasureUser> getUserData(String uid) async {
  final userDoc = await firestoreInstance.collection("user").doc(uid).get();
  if (userDoc.exists) return new TreasureUser.fromFirebase(userDoc.data());
}
