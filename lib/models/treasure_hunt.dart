import 'package:treasure_hunt/models/treasure_cache.dart';
import 'package:treasure_hunt/models/treasure_chart.dart';

class TreasureHunt extends TreasureChart {
  TreasureCache currentCache;
  int currentCacheIndex;
  bool hasWon;
  List<TreasureCache> foundCaches;

  TreasureHunt({
    String id,
    String title,
    String creatorId,
    String description,
    String initialClue,
    DateTime start,
    List<TreasureCache> treasureCaches,
  }) : super(
            id: id,
            title: title,
            creatorId: creatorId,
            description: description,
            initialClue: initialClue,
            start: start,
            treasureCaches: treasureCaches) {
    this.currentCacheIndex = -1;
    this.hasWon = false;
    this.foundCaches = [];
  }
  toFirebaseObject() {
    final hunt = super.toMap();
    hunt["currentCacheIndex"] = this.currentCacheIndex;
    hunt["hasWon"] = this.hasWon;
    hunt["currentCache"] = this.currentCache?.toFirebaseObject() ?? null;
    hunt["foundCaches"] = this
        .foundCaches
        .map((TreasureCache cache) => cache.toFirebaseObject())
        .toList();
    return hunt;
  }

  String get currentClue =>
      this.currentCacheIndex == -1 ? this.initialClue : currentCache.clue;

  bool checkHasWon() => this.currentCacheIndex > this.treasureCache.length;
  void setNextCache() {
    this.currentCacheIndex++;
    if (checkHasWon()) return;
    this.currentCache = this.treasureCache[currentCacheIndex];
    this.foundCaches.add(this.treasureCache[currentCacheIndex]);
  }
}
