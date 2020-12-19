import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:treasure_hunt/models/treasure_hunt.dart';

class ItemList extends HookWidget {
  const ItemList(this.type,
      {Key key, this.items, this.onTap, this.chart, this.onLongPress});
  final List items;
  final Function onTap;
  final Function onLongPress;
  final String type;
  final TreasureHunt chart;

  @override
  Widget build(BuildContext context) {
    if (items.length == 0) return Center(child: CircularProgressIndicator());
    Widget _itemBuilder(type, context, index) {
      switch (type) {
        case 'chart':
          final item = items[index];
          return ListTile(
            title: Text(item.title),
            subtitle: Text(item.description ?? null),
            onTap: () => onTap(context, index),
            onLongPress: () => onLongPress(index),
          );
          break;
        default:
          final item = items[index];
          return ListTile(
            leading: item.userIcon ?? null,
            title: Text(item.title),
            subtitle: Text(item.description ?? null),
            onTap: () => onTap(context, index),
          );
          break;
      }
    }

    return ListView.builder(
      itemBuilder: (context, index) => _itemBuilder(type, context, index),
      itemCount: items.length,
    );
  }
}
