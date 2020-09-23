import 'package:flutter/material.dart';
import 'package:treasure_hunt/components/item_list.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:treasure_hunt/hooks/useHuntAndChart.dart';
import 'package:provider/provider.dart';
import 'package:treasure_hunt/state/treasure_chart_state.dart';

class RootScreen extends HookWidget {
  RootScreen({this.title});
  static final routeName = 'root';
  final String title;

  @override
  Widget build(BuildContext context) {
    final charts =
        context.select((TreasureChartState state) => state.treasureCharts);
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
          Center(child: ItemList(items: treasureHunts.value)),
          Center(child: ItemList(items: charts)),
        ]),
        floatingActionButton: Builder(builder: (context) {
          return FloatingActionButton(
            onPressed: () {
              DefaultTabController.of(context).index == 0
                  ? Navigator.pushNamed(context, 'search',
                      arguments: addTreasureHunt)
                  : Navigator.pushNamed(context, 'chartTreasure');
            },
            child: Icon(Icons.add),
          );
        }),
      ),
    );
  }
}
