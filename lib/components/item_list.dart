import 'package:flutter/material.dart';

class ItemList extends StatelessWidget {
  const ItemList({Key key, this.items, this.onTap}) : super(key: key);
  final List items;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    if (items.length == 0) return Center(child: CircularProgressIndicator());

    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          leading: items[index].userIcon ?? null,
          title: Text(items[index].title),
          subtitle: Text(items[index].description ?? null),
          onTap: () => onTap(context, index),
        );
      },
      itemCount: items.length,
    );
  }
}
