import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:treasure_hunt/components/dialog.dart';
import 'package:treasure_hunt/components/input.dart';
import 'package:provider/provider.dart';
import 'package:treasure_hunt/models/treasure_cache.dart';
import 'package:treasure_hunt/models/treasure_hunt.dart';
import 'package:treasure_hunt/screens/add_treasure_caches.dart';
import 'package:treasure_hunt/state/treasure_chart_state.dart';
import 'package:treasure_hunt/utils/form_key.dart';

class EditTreasureChart extends HookWidget {
  EditTreasureChart({Key key}) : super(key: key);
  static const routeName = 'editChart';
  @override
  Widget build(BuildContext context) {
    final index = ModalRoute.of(context).settings.arguments;
    final state = context.watch<TreasureChartState>();

    TreasureHunt chart = state.treasureCharts[index];
    List<TreasureCache> caches = chart.treasureCache;

    void onTap(int idx) async {
      await dialog(
        context,
        title: '${chart.title}',
        dialogOptions: [
          FormBuilder(
            key: key,
            child: Column(
              children: [
                input(
                  label: 'Clue',
                  initialValue: caches[idx].clue,
                  onSaved: (value) {
                    chart.treasureCache[idx].clue = value;
                    context
                        .read<TreasureChartState>()
                        .updateTreasureChart(index, chart);
                  },
                  onError: (String value) =>
                      value.isEmpty ? 'This cache needs a clue!' : null,
                ),
                RaisedButton(
                  child: Text('Submit'),
                  onPressed: () {
                    if (key.currentState.validate()) {
                      key.currentState.save();
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      );
    }

    void onLongPress(TreasureCache cache) async {
      await dialog(context,
          title: 'Do you want to delete this cache?',
          dialogOptions: [
            SimpleDialogOption(
              child: Text('Yes'),
              onPressed: () {
                context
                    .read<TreasureChartState>()
                    .removeTreasureCache(chart.id, cache.id);
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
        title: Text('Edit Treasure Chart'),
        actions: [
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () => Navigator.pushNamed(
                context, AddTreasureCaches.routeName,
                arguments: {'index': index, 'chart': chart}),
          )
        ],
      ),
      body: Container(
        child: ListView.builder(
          itemBuilder: (context, index) {
            String subtitleSelector() => caches[index].clue != null
                ? caches[index].clue
                : 'Needs a clue!';
            return ListTile(
              onTap: () => onTap(index),
              onLongPress: () => onLongPress(caches[index]),
              subtitle: Text(subtitleSelector()),
              title: Text(
                  'Latitude: ${caches[index].location.latitude},\nLongitude: ${caches[index].location.longitude}'),
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
            );
          },
          itemCount: caches.length,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: hasClues ? Colors.blue : Colors.grey,
        child: Icon(Icons.publish),
        onPressed: _onPressed,
      ),
    );
  }
}
