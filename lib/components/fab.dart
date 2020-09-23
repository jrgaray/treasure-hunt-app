import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
part 'fab.g.dart';

@swidget
Widget fab(BuildContext context, String routeName, Function arguments) {
  _onPressed() => Navigator.pushNamed(context, routeName, arguments: arguments);
  return FloatingActionButton(
    child: Icon(Icons.add),
    onPressed: _onPressed,
  );
}
