import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:treasure_hunt/components/dialog.dart';
import 'package:provider/provider.dart';
import 'package:treasure_hunt/components/dialog_form.dart';
import 'package:treasure_hunt/firebase/store.dart';
import 'package:treasure_hunt/models/treasure_cache.dart';
import 'package:treasure_hunt/models/treasure_chart.dart';
import 'package:treasure_hunt/screens/add_treasure_caches.dart';
import 'package:treasure_hunt/state/user_state.dart';
import 'package:treasure_hunt/utils/getArgs.dart';

class EditTreasureChart extends HookWidget {
  EditTreasureChart({Key key}) : super(key: key);
  static const routeName = 'editChart';
  @override
  Widget build(BuildContext context) {
    TreasureChart passedChart = getRouteArgs(context);
    final charts = context.watch<List<TreasureChart>>();
    final userId = context.watch<UserState>().user.uid;
    final chart =
        charts.firstWhere((TreasureChart chart) => chart.id == passedChart.id);

    List<TreasureCache> caches = chart.treasureCache;

    void onTap(int index) async {
      await dialog(context, title: '${chart.title}', dialogOptions: [
        DialogForm(
          chart: chart,
          cache: caches[index],
          index: index,
        )
      ]);
    }

    void onLongPress(int index) async {
      await dialog(context,
          title: 'Do you want to delete this cache?',
          dialogOptions: [
            SimpleDialogOption(
              child: Text('Yes'),
              onPressed: () {
                deleteCache(userId, chart, caches[index], () {});
                Navigator.pop(context);
              },
            ),
            SimpleDialogOption(
              child: Text('No'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ]);
    }

    final hasClues = caches.every((cache) => cache.clue != null);

    void _onPressed() async {
      if (!hasClues) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Error'),
            content: Text('Add clues to all your caches yo'),
          ),
        );
        return;
      }
      await dialog(
        context,
        title: 'Publish chart?\nOnce you publish, you cannot edit your chart.',
        dialogOptions: [
          SimpleDialogOption(
            child: Text('Publish'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          SimpleDialogOption(
            child: Text('Not Yet'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Treasure Chart'),
        actions: [
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () => Navigator.pushNamed(
              context,
              AddTreasureCaches.routeName,
              arguments: chart,
            ),
          )
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: GestureDetector(
              onTap: () => print('hi'),
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${chart.title}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: MediaQuery.of(context).size.height / 20),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        '${chart.description}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.height / 40),
                      ),
                    ),
                    Text(
                      "Initial Clue:",
                      style: TextStyle(
                          fontSize: MediaQuery.of(context).size.height / 30),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Text(
                          "${chart.initialClue}",
                          style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height / 40),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(width: 2),
                ),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blueGrey, Colors.transparent]),
              ),
              child: ListView.builder(
                itemCount: caches.length,
                itemBuilder: (context, index) {
                  String subtitleSelector() => caches[index].clue != null
                      ? caches[index].clue
                      : 'Needs a clue!';
                  return Container(
                    child: ListTile(
                      onTap: () => onTap(index),
                      onLongPress: () => onLongPress(index),
                      subtitle: Text(subtitleSelector()),
                      title: Text(
                          'Latitude: ${caches[index].location.latitude},\nLongitude: ${caches[index].location.longitude}'),
                      leading: CircleAvatar(
                        backgroundColor: Colors.indigo,
                        child: Text('${index + 1}'),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: hasClues,
        child: FloatingActionButton(
          backgroundColor: hasClues ? Colors.blue : Colors.grey,
          child: const Icon(Icons.publish),
          onPressed: _onPressed,
        ),
      ),
    );
  }
}
