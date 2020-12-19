import 'package:treasure_hunt/models/treasure_search.dart';
import '../models/treasure_hunt.dart';
import 'package:flutter/material.dart';
import 'package:treasure_hunt/components/item_list.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:treasure_hunt/firebase/store.dart';
import 'package:treasure_hunt/screens/edit_treasure_chart.dart';
import 'package:treasure_hunt/components/fab_selector.dart';
import 'package:treasure_hunt/screens/treasure_hunt_create.dart';
import 'package:treasure_hunt/screens/treasure_hunt_search.dart';

class RootScreen extends HookWidget {
  RootScreen({this.title});
  static final routeName = 'root';
  final String title;

  /// TODO: Add hunting treasure pathway.
  void huntTreasure(BuildContext context, int index) {}

  @override
  Widget build(BuildContext context) {
    final charts = context.watch<List<TreasureHunt>>() ?? [];
    final hunts = context.watch<List<TreasureSearch>>() ?? [];

    // Navigate to the edit page, passing along the index of the chart that you // want to edit.
    Function(List<TreasureHunt>) editChart =
        (List charts) => (BuildContext context, int i) {
              Navigator.pushNamed(context, EditTreasureChart.routeName,
                  arguments: charts[i]);
            };
    void deleteChart(int index) async => await firebaseInstance
        .collection("charts")
        .doc(charts[index].id)
        .delete();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Hunt',
                icon: Icon(Icons.explore),
              ),
              Tab(
                text: 'Create',
                icon: Icon(Icons.create),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: ItemList(
                'hunt',
                items: hunts,
                onTap: huntTreasure,
              ),
            ),
            Center(
              child: ItemList(
                'chart',
                items: charts,
                onTap: editChart(charts),
                onLongPress: deleteChart,
              ),
            ),
          ],
        ),
        floatingActionButton: FabSelector(
          [
            {'name': TreasureHuntSearch.routeName, 'arguments': hunts},
            {
              'name': TreasureHuntCreate.routeName,
              'arguments': null,
            }
          ],
        ),
      ),
    );
  }
}
