import 'package:treasure_hunt/models/treasure_cache.dart';
import 'package:treasure_hunt/models/treasure_chart.dart';

class TreasureSearch extends TreasureChart {
  TreasureCache currentCache;
  int currentCacheIndex;
  bool hasWon;

  TreasureSearch({
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
  }
  toFirebaseObject() {
    final test = super.toMap();
    test["currentCacheIndex"] = this.currentCacheIndex;
    test["hasWon"] = this.hasWon;
    test["currentCache"] = this.currentCache?.toFirebaseObject() ?? null;
    return test;
  }

  String get currentClue =>
      this.currentCacheIndex == -1 ? this.initialClue : currentCache.clue;

  bool checkHasWon() => this.currentCacheIndex > this.treasureCache.length;
  void setNextCache() {
    this.currentCacheIndex++;
    if (checkHasWon()) return;
    this.currentCache = this.treasureCache[currentCacheIndex];
  }
}
