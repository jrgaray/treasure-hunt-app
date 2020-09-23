import 'package:flutter/material.dart';
import 'package:treasure_hunt/models/treasure_hunt.dart';
import 'package:treasure_hunt/state/treasure_chart_state.dart';
import '../components/input.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';

class NewTreasureChart extends HookWidget {
  static const routeName = 'newTreasureChart';
  static const String title = 'Create Treasure Hunt';

  @override
  Widget build(BuildContext context) {
    final _formKey = new GlobalKey<FormState>(debugLabel: 'chartTreasureKey');
    final newTreasureChart = new TreasureHunt();
    return Scaffold(
      appBar: AppBar(title: Text(NewTreasureChart.title)),
      body: Container(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Input(
                label: 'Title',
                onSaved: (newValue) => newTreasureChart.setTitle = newValue,
                onError: (value) {
                  if (value.isEmpty) {
                    return 'Cannot be empty';
                  }
                },
              ),
              Input(
                label: 'Description',
                onSaved: (newValue) =>
                    newTreasureChart.setDescription = newValue,
                onError: (value) => value.isEmpty ? 'Cannot be empty.' : null,
              ),
              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    newTreasureChart.setStart = new DateTime.now();
                    context
                        .read<TreasureChartState>()
                        .addTreasureChart(newTreasureChart);
                    Navigator.popAndPushNamed(context, 'newCache', arguments: {
                      'chart': newTreasureChart,
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
