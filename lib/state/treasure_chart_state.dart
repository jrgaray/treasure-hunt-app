import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:treasure_hunt/models/treasure_cache.dart';
import 'package:treasure_hunt/models/treasure_hunt.dart';

class TreasureChartState with ChangeNotifier {
  List<TreasureHunt> _treasureCharts = [];

  List<TreasureHunt> get treasureCharts => _treasureCharts;

  /// Set treasure charts with a pre-existing list of charts.
  void setTreasureCharts(List<TreasureHunt> initialTreasureCharts) {
    _treasureCharts = initialTreasureCharts;
    notifyListeners();
  }

  /// Add a new treasure chart to the list of charts.
  void addTreasureChart(TreasureHunt newTreasureChart) {
    _treasureCharts = [..._treasureCharts, newTreasureChart];
    notifyListeners();
  }

  /// Removed a treasure chart at a specific index.
  void removeTreasureChart(int index) {
    _treasureCharts.removeAt(index);
    _treasureCharts = _treasureCharts.map((chart) => chart).toList();
    notifyListeners();
  }

  /// Updates a treasure chart with a new chart.
  void updateTreasureChart(int index, TreasureHunt updatedTreasureChart) {
    _treasureCharts[index] = updatedTreasureChart;
    notifyListeners();
  }

  void addCache(String chartId, TreasureCache cache) {
    _treasureCharts
        .singleWhere((chart) => chart.id == chartId)
        .treasureCache
        .add(cache);
    notifyListeners();
  }

  void removeTreasureCache(String chartId, String cacheId) {
    assert(chartId != null && cacheId != null);
    _treasureCharts
        .firstWhere((chart) => chart.id == chartId)
        .treasureCache
        .removeWhere((cache) => cache.id == cacheId);
    notifyListeners();
  }
}
