import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:treasure_hunt/models/treasure_search.dart';
import 'package:treasure_hunt/utils/getArgs.dart';

class TreasureHuntSearch extends HookWidget {
  TreasureHuntSearch({Key key}) : super(key: key);
  static const routeName = 'search';

  @override
  Widget build(BuildContext context) {
    final List<TreasureSearch> hunts = getRouteArgs(context);

    /// On tap event handler. Adds a treasure hunt
    Function _onTap(treasureHunt) => () {
          // addTreasureHunt(treasureHunt);
          Navigator.pop(context);
        };

    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Container(
        child: ListView(
          children: hunts
              .map((treasureHunt) => ListTile(
                    title: Text(treasureHunt.title),
                    subtitle: Text(treasureHunt.description),
                    leading: CircleAvatar(
                      // backgroundImage: NetworkImage(treasureHunt.userAvatarUrl),
                      child: treasureHunt.userAvatarUrl != null
                          ? null
                          : Text(treasureHunt.userInitials),
                    ),
                    onTap: _onTap(treasureHunt),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
