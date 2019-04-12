import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/models/search_history_model.dart';
import 'package:tasty_tracks/pages/album/album.dart';
import 'package:tasty_tracks/pages/artist/artist.dart';
import 'package:tasty_tracks/pages/search/music_search_delegate.dart';
import 'package:tasty_tracks/pages/search/widgets/search_history.dart';
import 'package:tasty_tracks/pages/track/track.dart';

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

  final searchHistoryModel = SearchHistoryModel();

  @override
  initState() {
    super.initState();

    searchHistoryModel.loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<SearchHistoryModel>(
      model: searchHistoryModel,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: RaisedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FeatherIcons.search,
                      size: 18.0,
                    ),
                    const SizedBox(width: 8.0),
                    Text('Tracks, artists, or albums'),
                  ],
                ),
                color: Colors.white,
                onPressed: () {
                  // TODO When navigating back from a search result, search bar should be active
                  // TODO Consider not using showSearch for better behavior
                  showSearch(
                    context: context,
                    delegate: MusicSearchDelegate(
                      searchHistoryModel: searchHistoryModel,
                    ),
                  ).then((selectedItem) {
                    _handleSelectedItem(selectedItem);
                  });
                },
              ),
            ),
          ),
        ),
        body: SearchHistory(
          onSelectedItem: _handleSelectedItem,
        ),
      ),
    );
  }

  _handleSelectedItem(Object selectedItem) {
    if (selectedItem != null) {
      // Navigate to details page for selected item
      if (selectedItem is spotify.AlbumSimple) {
        searchHistoryModel.addAlbum(selectedItem);
        Navigator.of(context).pushNamed(
          AlbumPage.routeName,
          arguments: {
            'album_id': selectedItem.id,
            'album_image_url': selectedItem.images.first.url,
            'hero_suffix': '${selectedItem.id}-search',
          },
        );
      } else if (selectedItem is spotify.Artist) {
        searchHistoryModel.addArtist(selectedItem);
        Navigator.of(context).pushNamed(
          ArtistPage.routeName,
          arguments: {
            'artist_id': selectedItem.id,
            'artist_image_url': selectedItem.images.first.url,
            'hero_suffix': '${selectedItem.id}-search',
          },
        );
      } else if (selectedItem is spotify.Track) {
        searchHistoryModel.addTrack(selectedItem);
        if (selectedItem.album.images.isNotEmpty) {
          Navigator.of(context).pushNamed(
            TrackPage.routeName,
            arguments: {
              'track_id': selectedItem.id,
              'track_image_url': selectedItem.album.images.first.url,
              'hero_suffix': '${selectedItem.id}-search',
            },
          );
        } else {
          Navigator.of(context).pushNamed(
            TrackPage.routeName,
            arguments: {
              'track_id': selectedItem.id,
              'hero_suffix': '${selectedItem.id}-search',
            },
          );
        }
      }
    }
  }
}
