import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import '../utils/icon_dictionary.dart';
import './treasure_cache.dart';
import './user.dart';

class TreasureHunt {
  String _id;

  /// Title of the treasure hunt.
  String _title;

  /// Creator of the treasure hunt.
  User _creator;

  /// A short description of the treasure hunt.
  String _description;

  /// The treasure hunt's start date.
  DateTime _start;

  /// The treasure hunt's end date.
  DateTime _end;

  /// List of all this treasure hunt's caches.
  List<TreasureCache> _treasureCaches;

  /// The current cache the user is at.
  int _currentCacheIndex;

  /// Constructor for the TreasureHunt. All parameters are optional. Creates a
  /// Treasure Hunt for user's to hunt.
  TreasureHunt({
    String title,
    User creator,
    String description,
    DateTime start,
    DateTime end,
    List<TreasureCache> treasureCaches,
    int currentCacheIndex,
  })  : _id = Uuid().v4(),
        _title = title,
        _creator = creator,
        _description = description,
        _start = start,
        _end = end,
        _treasureCaches = treasureCaches ?? [],
        _currentCacheIndex = 0;

  // ************************************************************************
  //                                GETTERS
  // ************************************************************************

  /// Returns the title of the treasure hunt.
  String get id => _id;

  /// Returns the title of the treasure hunt.
  String get title => _title;

  /// Returns a user's avatar url.
  String get userAvatarUrl => _creator?.avatarUrl;

  /// Returns the creator's user name.
  String get creatorUserName => _creator?.fullName;

  /// Returns the creator's icon.
  Icon get userIcon => Icon(icons[_creator?.icon]);

  /// Returns the creator's initials
  String get userInitials => _creator?.initials;

  /// Returns a user's avatar url.
  String get description => _description;

  /// Returns the treasure hunt start date.
  DateTime get startDate => _start;

  /// Returns the treasure hunt end date.
  DateTime get endDate => _end;

  List<TreasureCache> get treasureCache => _treasureCaches;

  /// Returns the current cache the player is on.
  TreasureCache get currentCache => _treasureCaches[_currentCacheIndex];

  List<Marker> get markers {
    return _treasureCaches.asMap().entries.map((entry) {
      final cache = entry.value;
      final color = _treasureCaches.length - 1 == entry.key
          ? BitmapDescriptor.hueRed
          : BitmapDescriptor.hueAzure;
      return Marker(
        markerId: MarkerId(cache.id),
        position: cache.location,
        // consumeTapEvents: true,
        onTap: () => cache.onTap(id, cache.id),
        icon: BitmapDescriptor.defaultMarkerWithHue(color),
        draggable: true,
        onDragEnd: cache.onDrag,
        // infoWindow:
        //     InfoWindow(title: cache.location.toString(), snippet: cache.clue),
      );
    }).toList();
  }

  List<Polyline> get polylines => [
        Polyline(
          polylineId: PolylineId('$_title: $_description'),
          jointType: JointType.round,
          points: _treasureCaches
              .map((TreasureCache cache) => cache.location)
              .toList(),
        )
      ];
  // List<LatLng> get treasureCacheLocations =>
  //     _treasureCaches.map((cache) => cache.location).toList();

  // ************************************************************************
  //                                SETTERS
  // ************************************************************************

  /// Set TreasureChart title.
  set setTitle(String title) => _title = title;

  /// Set TreasureChart creator.
  set setCreator(User creator) => _creator = creator;

  /// Set TreasureChart description.
  set setDescription(String description) => _description = description;

  /// Set TreasureChart start date.
  set setStart(DateTime start) => _start = start;

  /// Set TreasureChart end date.
  set setEnd(DateTime end) => _end = end;

  /// Set TreasureChart caches.
  set setTreasureCaches(List<TreasureCache> treasureCaches) =>
      _treasureCaches = treasureCaches;

  // ************************************************************************
  //                                METHODS
  // ************************************************************************
  /// Add a cache to the treasure hunt.
  void addTreasureCache(TreasureCache cache) => _treasureCaches.add(cache);

  /// Moves the treasure hunt along to the next cache.
  void nextCache() {
    if (_currentCacheIndex <= 0 && _currentCacheIndex > _treasureCaches.length)
      _currentCacheIndex++;
  }
}
