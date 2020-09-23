import 'package:flutter/material.dart';
import 'package:treasure_hunt/app.dart';
import 'package:provider/provider.dart';
import 'package:treasure_hunt/state/treasure_chart_state.dart';
import 'package:treasure_hunt/state/user_state.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserState()),
        ChangeNotifierProvider(create: (_) => TreasureChartState()),
      ],
      child: App(),
    ),
  );
}
