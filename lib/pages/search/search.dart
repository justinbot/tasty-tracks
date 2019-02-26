import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/constants/sharedPrefs.dart';
import 'package:tasty_tracks/pages/search/music_search_delegate.dart';
import 'package:tasty_tracks/pages/search/widgets/search_history.dart';
import 'package:tasty_tracks/pages/track/track_details.dart';
import 'package:tasty_tracks/spotify_api.dart';

class SearchPage extends StatefulWidget {
  static final String routeName = '/search';
  final String pageTitle = 'Search';

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<spotify.Track> searchHistoryTracks = List();
  List<spotify.Artist> searchHistoryArtists = List();
  List<spotify.Album> searchHistoryAlbums = List();

  @override
  initState() {
    super.initState();

    _loadSearchHistory();
  }

  _loadSearchHistory() {
    // Load items from search history
    SharedPreferences.getInstance().then((prefs) {
      // TODO Limit length of search history
      List<String> searchHistoryTrackIds =
          prefs.getStringList(searchHistoryTracksKey) ?? List();
      List<String> searchHistoryArtistIds =
          prefs.getStringList(searchHistoryArtistsKey) ?? List();
      List<String> searchHistoryAlbumIds =
          prefs.getStringList(searchHistoryArtistsKey) ?? List();

      if (searchHistoryTrackIds.isNotEmpty) {
        spotifyApi.tracks.list(searchHistoryTrackIds).then((tracks) {
          setState(() {
            searchHistoryTracks = tracks.toList();
          });
        });
      }

      if (searchHistoryArtistIds.isNotEmpty) {
        spotifyApi.artists.list(searchHistoryTrackIds).then((artists) {
          setState(() {
            searchHistoryArtists = artists.toList();
          });
        });
      }

      if (searchHistoryAlbumIds.isNotEmpty) {
        spotifyApi.albums.list(searchHistoryTrackIds).then((albums) {
          setState(() {
            searchHistoryAlbums = albums.toList();
          });
        });
      }
    });
  }

  _handleSelectedItem(Object selectedItem) {
    if (selectedItem != null) {
      // Navigate to details page for selected item
      if (selectedItem is spotify.TrackSimple) {
        Navigator.of(context)
            .pushNamed(TrackDetailsPage.routeName + ':${selectedItem.id}');
      } else if (selectedItem is spotify.AlbumSimple) {
        // TODO
        print('TODO Album details');
      } else if (selectedItem is spotify.Artist) {
        // TODO
        print('TODO Artist details');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget searchHistory;

    if (searchHistoryTracks.isNotEmpty ||
        searchHistoryArtists.isNotEmpty ||
        searchHistoryAlbums.isNotEmpty) {
      searchHistory = SearchHistory(
        onTap: _handleSelectedItem,
        tracks: searchHistoryTracks,
        artists: searchHistoryArtists,
        albums: searchHistoryAlbums,
      );
    } else {
      searchHistory = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Search history will go here'),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: RaisedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FeatherIcons.search,
                    size: 18.0,
                  ),
                  Text('Search'),
                ],
              ),
              color: Colors.white,
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: MusicSearchDelegate(),
                ).then((selectedItem) {
                  _handleSelectedItem(selectedItem);
                  _loadSearchHistory();
                });
              },
            ),
          ),
        ),
      ),
      body: searchHistory,
    );
  }
}
