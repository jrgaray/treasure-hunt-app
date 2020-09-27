import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:treasure_hunt/components/item_list.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:treasure_hunt/models/treasure_hunt.dart';
import 'package:treasure_hunt/models/treasure_hunt_dto.dart';
import 'package:treasure_hunt/screens/edit_treasure_chart.dart';
import 'package:treasure_hunt/state/treasure_chart_state.dart';
import 'package:treasure_hunt/components/fab_selector.dart';
import 'package:treasure_hunt/screens/new_treasure_chart.dart';
import 'package:treasure_hunt/screens/treasure_hunt_search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

    Stream<List<QuerySnapshot>> getData() {
      Stream stream1 =
          FirebaseFirestore.instance.collection('charts').snapshots();
      Stream stream2 =
          FirebaseFirestore.instance.collection('hunts').snapshots();
      return StreamZip([stream1, stream2]);
    }

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
        body: StreamProvider<List<TreasureHunt>>.value(
          value: 
            child: Consumer<List<QuerySnapshot>>(
              builder: (context, List<QuerySnapshot> state, _) {
                final rawCharts = state[0];

                return Text('hi');
              },
            )),
        // body: StreamBuilder(
        //   stream: getData(),
        //   builder: (context, AsyncSnapshot<List> snapshot) {
        //     if (!snapshot.hasData)
        //       return Center(child: Text('hi'));
        //     else {
        //       final rawCharts = snapshot.data[0].docs;

        //       final rawHunts = snapshot.data[1].docs;
        //       final charts = TreasureHuntDTO().convertToTreasureHunt(rawCharts);
        //       context.watch<TreasureChartState>().setTreasureCharts(charts);
        //     }
        //     return TabBarView(children: [
        //       Center(
        //           child: ItemList('hunt',
        //               items: treasureHunts.value, onTap: huntTreasure)),
        //       Center(child: ItemList('chart', items: charts, onTap: editChart)),
        //     ]);
        //   },
        // ),
        floatingActionButton: FabSelector([
          {'name': TreasureHuntSearch.routeName, 'arguments': addTreasureHunt},
          {'name': NewTreasureChart.routeName, 'arguments': null}
        ]),
      ),
    );
  }
}
