import 'package:flutter/material.dart';

class ItemList extends StatelessWidget {
  const ItemList({Key key, this.items}) : super(key: key);
  final List items;

  @override
  Widget build(BuildContext context) {
    if (items.length == 0) return Center(child: CircularProgressIndicator());

    return ListView.builder(
      itemBuilder: (context, index) {
        return ListTile(
          leading: items[index].userIcon ?? null,
          title: Text(items[index].title),
          subtitle: Text(items[index].description ?? null),
          onTap: () => print('do an action'),
        );
      },
      itemCount: items.length,
    );
  }
}
