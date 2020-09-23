import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import '../utils/test_data.dart';

class TreasureHuntSearch extends HookWidget {
  TreasureHuntSearch({Key key}) : super(key: key);
  static const routeName = 'search';

  @override
  Widget build(BuildContext context) {
    final Function addTreasureHunt = ModalRoute.of(context).settings.arguments;

    /// On tap event handler. Adds a treasure hunt
    Function _onTap(treasureHunt) => () {
          addTreasureHunt(treasureHunt);
          Navigator.pop(context);
        };

    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Container(
        child: ListView(
          children: newTreasureHunts
              .map((treasureHunt) => ListTile(
                    title: Text(treasureHunt.title),
                    subtitle: Text(treasureHunt.description),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(treasureHunt.userAvatarUrl),
                      child: treasureHunt.userIcon != null
                          ? null
                          : Text(treasureHunt.userInitials),
                    ),
                    trailing:
                        Text(DateFormat.MEd().format(treasureHunt.startDate)),
                    onTap: _onTap(treasureHunt),
                  ))
              .toList(),
        ),
      ),
    );
  }
}
