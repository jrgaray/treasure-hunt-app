import 'package:flutter_hooks/flutter_hooks.dart';

final treasureHunts = useState([]);
void addTreasureHunt(newTreasureHunt) =>
    treasureHunts.value = [...treasureHunts.value, newTreasureHunt];
