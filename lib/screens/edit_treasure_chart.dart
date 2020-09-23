import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter/material.dart';

class EditTreasureChart extends HookWidget {
  static const routeName = 'editChart';
  @override
  Widget build(BuildContext context) {
    final index = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Treasure Chart'),
        ),
        body: Container(
            child: Center(
          child: Text('$index'),
        )));
  }
}
