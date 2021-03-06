import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
part 'fab_selector.g.dart';

@swidget
Widget fabSelector(BuildContext context, routes) {
  void _onPressed() {
    final index = DefaultTabController.of(context).index;
    Navigator.pushNamed(context, routes[index]['name']);
  }

  return FloatingActionButton(
    onPressed: _onPressed,
    child: Icon(Icons.add),
  );
}
