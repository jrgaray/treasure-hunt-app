import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
part 'fab_selector.g.dart';

Widget fabSelector(BuildContext context, routes) {
  void _onPressed() {
    final index = DefaultTabController.of(context).index;
    Navigator.pushNamed(context, routes[index]['name'],
        arguments: routes[index]['arguments']);
  }

  return FloatingActionButton(
    onPressed: _onPressed,
    child: Icon(Icons.add),
  );
}
