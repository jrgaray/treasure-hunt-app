import 'package:treasure_hunt/models/treasure_cache.dart';
import 'package:treasure_hunt/models/treasure_chart.dart';

class TreasureHunt extends TreasureChart {
  int currentCacheIndex;
  bool hasWon;
  List<TreasureCache> foundCaches;

  TreasureHunt({
    String id,
    String title,
    String creatorId,
    String description,
    String initialClue,
    int currentCacheIndex,
    bool hasWon,
    List<TreasureCache> foundCaches,
    List<TreasureCache> treasureCaches,
  }) : super(
            id: id,
            title: title,
            creatorId: creatorId,
            description: description,
            initialClue: initialClue,
            treasureCaches: treasureCaches) {
    this.currentCacheIndex = currentCacheIndex;
    this.hasWon = hasWon;
    this.foundCaches = foundCaches;
  }

  TreasureHunt.fromChart(TreasureChart chart, String id)
      : super(
            id: id,
            title: chart.title,
            creatorId: chart.creatorId,
            description: chart.description,
            initialClue: chart.initialClue,
            treasureCaches: chart.treasureCache.map((TreasureCache cache) {
              cache.groupId = id;
              return cache;
            }).toList()) {
    this.currentCacheIndex = -1;
    this.hasWon = false;
    this.foundCaches = [];
  }
  toFirebaseObject() {
    final hunt = super.toMap();
    hunt["currentCacheIndex"] = this.currentCacheIndex;
    hunt["hasWon"] = this.hasWon;
    hunt["foundCaches"] = this
        .foundCaches
        .map((TreasureCache cache) => cache.toFirebaseObject())
        .toList();
    return hunt;
  }

  String get currentClue => this.currentCacheIndex == -1
      ? this.initialClue
      : this.foundCaches.last.clue;

  bool checkHasWon() => this.currentCacheIndex > this.treasureCache.length - 2;

  void setNextCache() {
    this.currentCacheIndex++;
    this.foundCaches.add(this.treasureCache[currentCacheIndex]);
    if (checkHasWon()) {
      this.hasWon = true;
      return;
    }
  }
}
