import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:treasure_hunt/models/treasure_cache.dart';
import 'package:treasure_hunt/models/treasure_hunt.dart';
import 'package:treasure_hunt/models/treasure_search.dart';

final firebaseInstance = FirebaseFirestore.instance;

final addChart = (Map data) => firebaseInstance.collection("charts").add(data);
void deleteCache(
    TreasureHunt chart, TreasureCache cache, Function setChart) async {
  await firebaseInstance.collection("charts").doc(chart.id).update({
    "treasureCaches": FieldValue.arrayRemove([cache.toFirebaseObject()])
  });
  final caches = [...chart.treasureCache];
  caches.removeWhere((TreasureCache tCache) => tCache.id == cache.id);
  final newChart = new TreasureHunt.copy(chart);
  newChart.setTreasureCaches = caches;
  // setChart(newChart);
}

void saveClue(String clue, String chartId, int cacheIndex) async {
  final chartDoc =
      await firebaseInstance.collection("charts").doc(chartId).get();
  final chartData = chartDoc.data();
  chartData['treasureCaches'][cacheIndex]['clue'] = clue;
  await firebaseInstance
      .collection('charts')
      .doc(chartId)
      .update({"treasureCaches": chartData["treasureCaches"]});
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
          treasureCaches:
              firestoreHunt["treasureCaches"]?.map<TreasureCache>((cache) {
            return new TreasureCache(
                id: cache["id"],
                groupId: cache["groupId"],
                location: LatLng(
                    cache["location"].latitude, cache["location"].longitude),
                clue: cache["clue"]);
          })?.toList(),
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
          treasureCaches:
              firestoreHunt["treasureCaches"].map<TreasureCache>((cache) {
            return new TreasureCache(
                id: cache["id"],
                groupId: cache["groupId"],
                location: LatLng(
                    cache["location"].latitude, cache["location"].longitude),
                clue: cache["clue"]);
          }).toList(),
        ),
      )
      .toList();
};

// final stream = () => firebaseInstance.collection("charts").snapshots();
final chartStream = () => firebaseInstance
    .collection("charts")
    .snapshots()
    ?.map((QuerySnapshot snapshot) => convertToHunt(snapshot));

final huntStream = () => firebaseInstance
    .collection("hunts")
    .snapshots()
    ?.map((QuerySnapshot snapshot) => convertToSearch(snapshot));
