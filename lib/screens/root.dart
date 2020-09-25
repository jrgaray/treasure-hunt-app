import 'package:flutter/material.dart';
import 'package:treasure_hunt/components/item_list.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:treasure_hunt/screens/edit_treasure_chart.dart';
import 'package:treasure_hunt/state/treasure_chart_state.dart';
import 'package:treasure_hunt/components/fab_selector.dart';
import 'package:treasure_hunt/screens/new_treasure_chart.dart';
import 'package:treasure_hunt/screens/treasure_hunt_search.dart';

class RootScreen extends HookWidget {
  RootScreen({this.title});
  static final routeName = 'root';
  final String title;

  // Navigate to the edit page, passing along the index of the chart that you
  // want to edit.
  void editChart(BuildContext context, int index) {
    Navigator.pushNamed(context, EditTreasureChart.routeName, arguments: index);
  }

  /// TODO: Add hunting treasure pathway.
  void huntTreasure(BuildContext context, int index) {}

  @override
  Widget build(BuildContext context) {
    final charts =
        context.select((TreasureChartState state) => state.treasureCharts);
    // TODO: Move treasure hunts state into provider.
    final treasureHunts = useState([]);
    void addTreasureHunt(newTreasureHunt) =>
        treasureHunts.value = [...treasureHunts.value, newTreasureHunt];
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
            title: Text(title),
            bottom: TabBar(
              tabs: [
                Tab(text: 'Hunt', icon: Icon(Icons.explore)),
                Tab(text: 'Create', icon: Icon(Icons.create)),
              ],
            )),
        body: TabBarView(children: [
          Center(
              child: ItemList('hunt',
                  items: treasureHunts.value, onTap: huntTreasure)),
          Center(child: ItemList('chart', items: charts, onTap: editChart)),
        ]),
        floatingActionButton: FabSelector([
          {'name': TreasureHuntSearch.routeName, 'arguments': addTreasureHunt},
          {'name': NewTreasureChart.routeName, 'arguments': null}
        ]),
      ),
    );
  }
}
