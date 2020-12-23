import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:treasure_hunt/firebase/store.dart';
import 'package:provider/provider.dart';
import 'package:treasure_hunt/models/treasure_hunt.dart';
import 'package:treasure_hunt/models/treasure_user.dart';

class TreasureHuntSearch extends HookWidget {
  TreasureHuntSearch({Key key}) : super(key: key);
  static const routeName = 'search';

  @override
  Widget build(BuildContext context) {
    final allCharts = convertToSearch(context.watch<QuerySnapshot>());
    final user = context.watch<User>();
    final mapOfUsers = context.watch<Map<String, TreasureUser>>();

    /// On tap event handler. Adds a treasure hunt
    Function _onTap(TreasureHunt treasureHunt) => () {
          addHunt(user.uid, treasureHunt);
          Navigator.pop(context);
        };

    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: Container(
        child: ListView(
          children: allCharts.map(
            (treasureHunt) {
              final leadingImage =
                  mapOfUsers[treasureHunt.creatorId]?.avatarUrl != null
                      ? CircleAvatar(
                          backgroundColor: Colors.blue,
                          backgroundImage: NetworkImage(
                              mapOfUsers[treasureHunt.creatorId]?.avatarUrl),
                        )
                      : CircleAvatar(
                          backgroundColor: Colors.blue,
                          child:
                              Text(mapOfUsers[treasureHunt.creatorId].initials),
                        );

              return ListTile(
                title: Text(treasureHunt.title),
                subtitle: Text(treasureHunt.description),
                leading: leadingImage,
                onTap: _onTap(treasureHunt),
              );
            },
          ).toList(),
        ),
      ),
    );
  }
}
