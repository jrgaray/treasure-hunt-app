import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:treasure_hunt/firebase/auth.dart';
import 'package:treasure_hunt/models/treasure_search.dart';
import 'package:treasure_hunt/models/treasure_user.dart';
import 'package:treasure_hunt/screens/login.dart';
import '../models/treasure_chart.dart';
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
    final authUser = context.watch<User>();
    final hunts = context.watch<List<TreasureSearch>>() ?? [];
    final charts = context.watch<List<TreasureChart>>() ?? [];
    final docSnap = context.watch<DocumentSnapshot>();
    final user = docSnap != null && docSnap.data() != null
        ? new TreasureUser.fromFirebase(docSnap.data())
        : null;

    useEffect(() {
      if (authUser == null) {
        Future.microtask(
            () => Navigator.popAndPushNamed(context, Login.routeName));
      }
      return;
    }, [authUser]);

    if (user == null || authUser == null)
      return DefaultTabController(
        length: 2,
        child: Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );

    Function(List<TreasureChart>) editChart =
        (List charts) => (BuildContext context, int i) {
              Navigator.pushNamed(context, EditTreasureChart.routeName,
                  arguments: charts[i]);
            };

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            Padding(
              padding: EdgeInsets.only(top: 5, right: 5),
              child: Container(
                height: 50,
                width: 50,
                child: ClipOval(
                  child: Material(
                    elevation: 100,
                    shape: CircleBorder(
                      side: BorderSide(
                        width: 1,
                        color: Colors.white,
                      ),
                    ),
                    child: InkWell(
                      child: user.avatarUrl != null && user.avatarUrl.isNotEmpty
                          ? Image(
                              fit: BoxFit.cover,
                              image: NetworkImage(user.avatarUrl),
                            )
                          : Center(
                              child: Text(user.initials,
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                      onTap: () async {
                        await signOut();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
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
                // onTap: huntTreasure,
              ),
            ),
            Center(
              child: ItemList(
                'chart',
                items: charts,
                onTap: editChart(charts),
                onLongPress: (index) => deleteChart(index, charts, user.uid),
              ),
            ),
          ],
        ),
        floatingActionButton: FabSelector(
          [
            {
              'name': TreasureHuntSearch.routeName,
              'arguments': hunts,
            },
            {
              'name': TreasureChartCreate.routeName,
              'arguments': null,
            }
          ],
        ),
      ),
    );
  }
}
