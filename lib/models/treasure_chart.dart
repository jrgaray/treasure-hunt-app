import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'treasure_cache.dart';
import 'treasure_user.dart';

class TreasureChart {
  /// Id of the treasure hunt.
  String _id;

  /// Title of the treasure hunt.
  String _title;

  /// Creator of the treasure hunt.
  TreasureUser _creator;

  /// A short description of the treasure hunt.
  String _description;

  /// The treasure hunt's start date.
  DateTime _start;

  /// List of all this treasure hunt's caches.
  List<TreasureCache> _treasureCaches;

  /// First clue to kick off the treasure hunt.
  String _initialClue;

  /// Constructor for the TreasureChart. All parameters are optional. Creates a
  /// Treasure Hunt for user's to hunt.
  TreasureChart({
    String id,
    String title,
    TreasureUser creator,
    String description,
    String initialClue,
    DateTime start,
    List<TreasureCache> treasureCaches,
  })  : _id = id ?? Uuid().v4(),
        _title = title,
        _creator = creator,
        _description = description,
        _start = start,
        _treasureCaches = treasureCaches ?? [],
        _initialClue = initialClue;

  TreasureChart.copy(TreasureChart original) {
    _id = original.id;
    _title = original.title;
    _creator = original._creator;
    _description = original._description;
    _start = original.startDate;
    _treasureCaches = original.treasureCache;
    _initialClue = original.initialClue;
  }

  // ************************************************************************
  //                                GETTERS
  // ************************************************************************

  /// Returns the title of the treasure hunt.
  String get id => _id;

  /// Returns the title of the treasure hunt.
  String get title => _title;

  /// Returns a user's avatar url.
  String get description => _description;

  /// Returns the treasure hunt start date.
  DateTime get startDate => _start;

  /// Returns a list of treasure caches
  List<TreasureCache> get treasureCache => _treasureCaches;

  /// Returns the initial clue to start the treasure hunt.
  String get initialClue => _initialClue;

  TreasureUser get creator => _creator;

  // ************************************************************************
  //                                SETTERS
  // ************************************************************************

  /// Set TreasureChart title.
  set setTitle(String title) => _title = title;

  /// Set TreasureChart creator.
  set setCreator(TreasureUser creator) => _creator = creator;

  /// Set TreasureChart description.
  set setDescription(String description) => _description = description;

  /// Set TreasureChart start date.
  set setStart(DateTime start) => _start = start;

  /// Set TreasureChart caches.
  set setTreasureCaches(List<TreasureCache> treasureCaches) =>
      _treasureCaches = treasureCaches;

  /// Set TreasureChart initialClue.
  set setInitialClue(String clue) => _initialClue = clue;

  // ************************************************************************
  //                                METHODS
  // ************************************************************************
  /// Add a cache to the treasure hunt.
  void addTreasureCache(TreasureCache cache) => _treasureCaches.add(cache);

  Map<String, dynamic> toMap() => {
        "id": _id,
        "initialClue": _initialClue,
        "title": _title,
        "creator": _creator.uid,
        "description": description,
        "treasureCaches": treasureCache
            .map((cache) => {
                  "id": cache.id,
                  "groupId": id,
                  "clue": cache.clue,
                  "location": GeoPoint(
                      cache.location.latitude, cache.location.longitude)
                })
            .toList()
      };
}
