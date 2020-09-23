import 'package:flutter/material.dart';
import 'package:treasure_hunt/components/fab.dart';

Widget fabSelector(int index, List<Function> args, List<String> routes) {
  return Fab(routes[index], args[index]);
}
