import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';
import 'package:treasure_hunt/components/dialog.dart';
import 'package:treasure_hunt/components/input.dart';
import 'package:treasure_hunt/components/item_list.dart';
import 'package:provider/provider.dart';
import 'package:treasure_hunt/models/treasure_cache.dart';
import 'package:treasure_hunt/state/treasure_chart_state.dart';
import 'package:treasure_hunt/utils/form_key.dart';

class EditTreasureChart extends HookWidget {
  static const routeName = 'editChart';
  @override
  Widget build(BuildContext context) {
    print('edit rebuilt');
    final index = ModalRoute.of(context).settings.arguments;
    final chart = context
        .select((TreasureChartState state) => state.treasureCharts[index]);
    List<TreasureCache> caches = chart.treasureCache;
    void onTap(BuildContext ctx, int idx, String clue) async {
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
                  initialValue: clue,
                  onSaved: (value) {
                    chart.treasureCache[idx].clue = value;
                    final huntInfo = ctx
                        .read<TreasureChartState>()
                        .retrieveHuntInfo(chart.id);
                    ctx
                        .read<TreasureChartState>()
                        .updateTreasureChart(huntInfo['indexOfHunt'], chart);
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Treasure Chart'),
      ),
      body: Container(
          child: ItemList(
        'editChart',
        items: caches,
        onTap: onTap,
        chart: chart,
      )),
    );
  }
}
