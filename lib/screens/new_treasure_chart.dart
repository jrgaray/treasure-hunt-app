import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:treasure_hunt/models/treasure_hunt.dart';
import 'package:treasure_hunt/screens/add_treasure_caches.dart';
import 'package:treasure_hunt/state/treasure_chart_state.dart';
import '../components/input.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:treasure_hunt/utils/form_key.dart';

class NewTreasureChart extends HookWidget {
  static const routeName = 'newTreasureChart';
  static const String title = 'Create Treasure Hunt';

  @override
  Widget build(BuildContext context) {
    final newTreasureChart = new TreasureHunt();
    return Scaffold(
      appBar: AppBar(title: Text(NewTreasureChart.title)),
      body: Container(
        child: FormBuilder(
          key: key,
          child: Column(
            children: [
              input(
                label: 'Title',
                onSaved: (newValue) => newTreasureChart.setTitle = newValue,
                onError: (value) {
                  if (value.isEmpty) {
                    return 'Cannot be empty';
                  }
                },
              ),
              input(
                label: 'Description',
                onSaved: (newValue) =>
                    newTreasureChart.setDescription = newValue,
                onError: (value) => value.isEmpty ? 'Cannot be empty.' : null,
              ),
              RaisedButton(
                onPressed: () {
                  if (key.currentState.validate()) {
                    key.currentState.save();
                    newTreasureChart.setStart = new DateTime.now();
                    context
                        .read<TreasureChartState>()
                        .addTreasureChart(newTreasureChart);
                    Navigator.pushReplacementNamed(
                        context, AddTreasureCaches.routeName,
                        arguments: {
                          'chart': newTreasureChart,
                          'index': context
                                  .read<TreasureChartState>()
                                  .treasureCharts
                                  .length -
                              1
                        });
                  }
                },
                child: Text('Continue'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
