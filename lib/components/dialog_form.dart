import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:treasure_hunt/components/input.dart';
import 'package:treasure_hunt/firebase/store.dart';
import 'package:treasure_hunt/models/treasure_cache.dart';
import 'package:treasure_hunt/models/treasure_hunt.dart';
import 'package:treasure_hunt/utils/form_key.dart';

class DialogForm extends HookWidget {
  const DialogForm({
    Key key,
    this.chart,
    this.cache,
    this.index,
    this.updateChart,
  }) : super(key: key);

  final TreasureHunt chart;
  final TreasureCache cache;
  final int index;
  final Function(TreasureHunt) updateChart;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: key,
      child: Column(
        children: [
          input(
            label: 'Clue',
            type: 'clue',
            initialValue: cache.clue,
            onSaved: (value) {
              // Save the value to firebase.
              saveClue(value, cache.groupId, index);
              // Save the value to our local state.
              final caches = [...chart.treasureCache];
              caches[index].clue = value;
              final newChart = new TreasureHunt.copy(chart);
              newChart.setTreasureCaches = caches;
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
    );
  }
}