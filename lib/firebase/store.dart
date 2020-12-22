import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:treasure_hunt/models/treasure_cache.dart';
import 'package:treasure_hunt/models/treasure_chart.dart';
import 'package:treasure_hunt/models/treasure_search.dart';

// Firestore instance.
final firestoreInstance = FirebaseFirestore.instance;

// Path to getting a collection within the users doc.
final getCollectionFromUser = (String userId, String collection) =>
    firestoreInstance.collection("user").doc(userId).collection(collection);

//////////////////////////////// CHART CRUD ////////////////////////////////

// Delete a chart.
void deleteChart(int index, List<TreasureChart> charts, String userId) async =>
    await getCollectionFromUser(userId, "chart").doc(charts[index].id).delete();

// Add a chart to a user.
Future<void> Function(String, TreasureChart) addChart =
    (String userId, TreasureChart chart) async =>
        await getCollectionFromUser(userId, "chart")
            .doc(chart.id)
            .set(chart.toMap());

// Delete a cache from chart.
void deleteCache(
  String userId,
  TreasureChart chart,
  TreasureCache cache,
  Function setChart,
) async {
  await getCollectionFromUser(userId, "chart").doc(chart.id).update(
    {
      "treasureCaches": FieldValue.arrayRemove(
        [
          cache.toFirebaseObject(),
        ],
      )
    },
  );
}

// Save a clue to a cache.
void saveClue(
    String clue, String chartId, int cacheIndex, String userId) async {
  final chartRef = getCollectionFromUser(userId, "charts").doc(chartId);
  final chartDoc = await chartRef.get();
  final chartData = chartDoc.data();
  chartData['treasureCaches'][cacheIndex]['clue'] = clue;
  await chartRef.update(
    {
      "treasureCaches": chartData["treasureCaches"],
    },
  );
}

///////////////////////////// User Functions /////////////////////////////

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

//////////////////////////// HELPER Functions ////////////////////////////

// Convert snapshot to a list of Treasure Searches.
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

// Convert a snapshot to a list of Treasure Charts.
List<TreasureChart> Function(QuerySnapshot) convertToChart =
    (QuerySnapshot snapshot) {
  final docs = snapshot.docs ?? [];
  final data = docs.map((document) => (document.data())).toList();
  return data
      .map<TreasureChart>(
        (firestoreHunt) => new TreasureChart(
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

//////////////////////////// STREAM Functions ////////////////////////////

Stream<List<TreasureChart>> Function(String) userCharts =
    (String userId) => getCollectionFromUser(userId, "chart").snapshots()?.map(
          (QuerySnapshot snapshot) => convertToChart(snapshot),
        );

Stream<List<TreasureSearch>> Function(String) userHunts =
    (String userId) => getCollectionFromUser(userId, "chart").snapshots()?.map(
          (QuerySnapshot snapshot) => convertToSearch(snapshot),
        );

Stream<DocumentSnapshot> streamData(String uid) {
  return firestoreInstance.collection('user').doc(uid).snapshots();
}
