import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/models/search_history_model.dart';
import 'package:tasty_tracks/pages/search/music_search_delegate.dart';
import 'package:tasty_tracks/pages/search/widgets/search_history.dart';
import 'package:tasty_tracks/pages/track/track.dart';
import 'package:tasty_tracks/pages/album/album.dart';

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

  final history = SearchHistoryModel();

  @override
  initState() {
    super.initState();

    history.loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<SearchHistoryModel>(
      model: history,
      child: Scaffold(
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
                  // TODO When navigating back from a search result, search bar should be active
                  // TODO Consider not using showSearch for better behavior
                  showSearch(
                    context: context,
                    delegate: MusicSearchDelegate(),
                  ).then((selectedItem) {
                    _handleSelectedItem(selectedItem);
                  });
                },
              ),
            ),
          ),
        ),
        body: SearchHistory(
          onTapItem: _handleSelectedItem,
        ),
      ),
    );
  }

  _handleSelectedItem(Object selectedItem) {
    if (selectedItem != null) {
      // Navigate to details page for selected item
      if (selectedItem is spotify.AlbumSimple) {
        history.addAlbum(selectedItem);
        Navigator.of(context)
            .pushNamed(AlbumPage.routeName + ':${selectedItem.id}');
      } else if (selectedItem is spotify.ArtistSimple) {
        history.addArtist(selectedItem);
        // TODO
        print('TODO Artist details');
      } else if (selectedItem is spotify.TrackSimple) {
        history.addTrack(selectedItem);
        Navigator.of(context)
            .pushNamed(TrackDetailsPage.routeName + ':${selectedItem.id}');
      }
    }
  }
}
