import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
part 'fab_selector.g.dart';

@swidget
Widget fabSelector(BuildContext context, routes) {
  void _onPressed() {
    final index = DefaultTabController.of(context).index;
    Navigator.pushNamed(context, routes[index]['name'],
        arguments: routes[index]['arguments']);
  }

  return FloatingActionButton(
    onPressed: _onPressed,
    // onPressed: () {
    //   DefaultTabController.of(context).index == 0
    //       ? Navigator.pushNamed(context, TreasureHuntSearch.routeName,
    //           arguments: addTreasureHunt)
    //       : Navigator.pushNamed(context, NewTreasureChart.routeName);
    // },
    child: Icon(Icons.add),
  );
}
