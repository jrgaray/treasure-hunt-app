import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:treasure_hunt/models/treasure_hunt.dart';
import 'package:treasure_hunt/screens/add_treasure_caches.dart';
import '../components/input.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:treasure_hunt/utils/form_key.dart';

class TreasureHuntCreate extends HookWidget {
  static const routeName = 'newTreasureChart';
  static const String title = 'Create Treasure Hunt';

  @override
  Widget build(BuildContext context) {
    final newTreasureChart = new TreasureHunt();
    return Scaffold(
      appBar: AppBar(title: Text(TreasureHuntCreate.title)),
      body: Container(
        child: FormBuilder(
          key: key,
          child: Column(
            children: [
              input(
                label: 'Title',
                onSaved: (newValue) => newTreasureChart.setTitle = newValue,
                onError: (value) => value.isEmpty ? 'Cannot be empty' : null,
              ),
              input(
                label: 'Description',
                onSaved: (newValue) =>
                    newTreasureChart.setDescription = newValue,
                onError: (value) => value.isEmpty ? 'Cannot be empty.' : null,
              ),
              input(
                label: 'Initial Clue',
                type: 'clue',
                onSaved: (newValue) {
                  newTreasureChart.setInitialClue = newValue;
                },
                onError: (value) => value.isEmpty ? 'Cannot be empty.' : null,
              ),
              RaisedButton(
                onPressed: () {
                  if (key.currentState.validate()) {
                    key.currentState.save();
                    newTreasureChart.setStart = new DateTime.now();
                    Navigator.pushReplacementNamed(
                      context,
                      AddTreasureCaches.routeName,
                      arguments: newTreasureChart,
                    );
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
