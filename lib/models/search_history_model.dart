import 'dart:collection';

import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/spotify_api.dart';

class SearchHistoryModel extends Model {
  static const String albumPrefsKey = 'search-history-albums';
  static const String artistPrefsKey = 'search-history-artists';
  static const String trackPrefsKey = 'search-history-tracks';
  static const int _maxItems = 5;

  final Map<String, List<String>> historyItems = {
    albumPrefsKey: [],
    artistPrefsKey: [],
    trackPrefsKey: [],
  };

  SharedPreferences _prefs;

//  UnmodifiableListView<String> get albumItems =>
//      UnmodifiableListView(historyItems[albumPrefsKey]);
//
//  UnmodifiableListView<String> get artistItems =>
//      UnmodifiableListView(historyItems[artistPrefsKey]);
//
//  UnmodifiableListView<String> get trackItems =>
//      UnmodifiableListView(historyItems[trackPrefsKey]);

  /// Save these items to persistent storage
  _save(String prefsKey) {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setStringList(prefsKey, historyItems[prefsKey]);

      notifyListeners();
    });
  }

  /// Load search history items from persistent storage
  Future<void> loadItems() async {
    _prefs = await SharedPreferences.getInstance();

    historyItems[albumPrefsKey] = _prefs.getStringList(albumPrefsKey) ?? List();
    print(historyItems[albumPrefsKey]);
    historyItems[artistPrefsKey] =
        _prefs.getStringList(artistPrefsKey) ?? List();
    print(historyItems[artistPrefsKey]);
    historyItems[trackPrefsKey] = _prefs.getStringList(trackPrefsKey) ?? List();
    print(historyItems[trackPrefsKey]);

    notifyListeners();
  }

  Future<UnmodifiableListView<spotify.Album>> albumItems() async {
    List<String> albumIds = historyItems[albumPrefsKey];
    if (albumIds.isEmpty) {
      return UnmodifiableListView([]);
    } else {
      print('FETCHING HISTORY ALBUMS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      Iterable<spotify.Album> albums = await spotifyApi.albums.list(albumIds);
      return UnmodifiableListView(albums);
    }
  }

  Future<UnmodifiableListView<spotify.Artist>> artistItems() async {
    List<String> artistIds = historyItems[artistPrefsKey];
    if (artistIds.isEmpty) {
      return UnmodifiableListView([]);
    } else {
      print('FETCHING HISTORY ARTISTS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      Iterable<spotify.Artist> artists = await spotifyApi.artists.list(artistIds);
      return UnmodifiableListView(artists);
    }
  }

  Future<UnmodifiableListView<spotify.Track>> trackItems() async {
    List<String> trackIds = historyItems[trackPrefsKey];
    if (trackIds.isEmpty) {
      print('No tracks items');
      return UnmodifiableListView([]);
    } else {
      print('FETCHING HISTORY TRACKS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      Iterable<spotify.Track> tracks = await spotifyApi.tracks.list(trackIds);
      return UnmodifiableListView(tracks);
    }
  }

  add(Object item) {
    print('Adding item to history!');
    SharedPreferences.getInstance().then((prefs) {
      String itemId;
      String prefsKey;
      if (item is spotify.TrackSimple) {
        itemId = item.id;
        prefsKey = trackPrefsKey;
      } else if (item is spotify.ArtistSimple) {
        itemId = item.id;
        prefsKey = artistPrefsKey;
      } else if (item is spotify.AlbumSimple) {
        itemId = item.id;
        prefsKey = albumPrefsKey;
      }

      if (prefsKey != null) {
        List<String> newItems = historyItems[prefsKey];
        if (!newItems.contains(itemId)) {
          newItems.add(itemId);
          // Cap to max items
          if (newItems.length > _maxItems) {
            newItems.removeAt(0);
          }

          historyItems[prefsKey] = newItems;
          _save(prefsKey);

          notifyListeners();
        }
      }
    });
  }

  clear() {
    historyItems.keys.forEach((prefsKey) {
      historyItems[prefsKey].clear();
      _save(prefsKey);
    });
  }
}
