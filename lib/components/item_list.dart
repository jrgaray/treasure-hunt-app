import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:treasure_hunt/models/treasure_hunt.dart';
import 'package:treasure_hunt/state/treasure_chart_state.dart';
import 'package:provider/provider.dart';

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
        case 'editChart':
          return Builder(builder: (ctx) {
            final cacheInfo = ctx.select((TreasureChartState state) {
              final cache = state.treasureCharts
                  .firstWhere((TreasureHunt char) => char.id == chart.id)
                  .treasureCache[index];
              return {
                'cache': cache,
                'clue': cache.clue,
                'lat': cache.location.latitude,
                'long': cache.location.longitude,
              };
            });

            return ListTile(
              onTap: () => onTap(ctx, index, cacheInfo['clue']),
              onLongPress: () => onLongPress(cacheInfo['cache']),
              subtitle: Text(cacheInfo['clue'] != null
                  ? cacheInfo['clue']
                  : 'Needs a clue!'),
              title: Text(
                  'Latitude: ${cacheInfo['lat']},\nLongitude: ${cacheInfo['long']}'),
              leading: CircleAvatar(
                child: Text('${index + 1}'),
              ),
            );
          });
          break;
        default:
          final item = items[index];
          return ListTile(
            leading: Text(item.creator.icon) ?? null,
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
