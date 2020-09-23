import 'package:flutter_hooks/flutter_hooks.dart';

final treasureHunts = useState([]);
// final treasureCharts = useState([]);
void addTreasureHunt(newTreasureHunt) =>
    treasureHunts.value = [...treasureHunts.value, newTreasureHunt];

// void addTreasureChart() {
//   treasureCharts.value = [...treasureCharts.value, 'placeholder'];
// }
