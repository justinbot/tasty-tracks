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
import 'package:tasty_tracks/widgets/error_page.dart';

class SearchPage extends StatefulWidget {
  static final String routeName = '/search';
  final String pageTitle = 'Search';

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _isBusy;
  bool _hasError;

  SearchHistoryModel _searchHistoryModel;

//  Iterable<spotify.Album> _albums;
//  Iterable<spotify.Artist> _artists;
//  Iterable<spotify.Track> _tracks;

  @override
  initState() {
    super.initState();

    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Scaffold(
        body: SafeArea(
          child: ErrorPage(
            errorText: 'Failed to load searches :(',
            onRetry: () => _loadData(),
          ),
        ),
      );
    } else if (_isBusy) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else {
      return ScopedModel<SearchHistoryModel>(
        model: _searchHistoryModel,
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
                        searchHistoryModel: _searchHistoryModel,
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
  }

  _handleSelectedItem(Object selectedItem) {
    if (selectedItem != null) {
      // Navigate to details page for selected item
      if (selectedItem is spotify.AlbumSimple) {
        _searchHistoryModel.addAlbum(selectedItem);
        String imageUrl;
        if (selectedItem.images.isNotEmpty) {
          imageUrl = selectedItem.images.first.url;
        }

        Navigator.of(context).pushNamed(
          AlbumPage.routeName,
          arguments: {
            'album_id': selectedItem.id,
            'album_image_url': imageUrl,
            'hero_suffix': '${selectedItem.id}-search',
          },
        );
      } else if (selectedItem is spotify.Artist) {
        _searchHistoryModel.addArtist(selectedItem);
        String imageUrl;
        if (selectedItem.images.isNotEmpty) {
          imageUrl = selectedItem.images.first.url;
        }

        Navigator.of(context).pushNamed(
          ArtistPage.routeName,
          arguments: {
            'artist_id': selectedItem.id,
            'artist_image_url': imageUrl,
            'hero_suffix': '${selectedItem.id}-search',
          },
        );
      } else if (selectedItem is spotify.Track) {
        _searchHistoryModel.addTrack(selectedItem);
        String imageUrl;
        if (selectedItem.album.images.isNotEmpty) {
          imageUrl = selectedItem.album.images.first.url;
        }

        Navigator.of(context).pushNamed(
          TrackPage.routeName,
          arguments: {
            'track_id': selectedItem.id,
            'track_image_url': imageUrl,
            'hero_suffix': '${selectedItem.id}-search',
          },
        );
      }
    }
  }

  void _loadData() async {
    setState(() {
      _isBusy = true;
      _hasError = false;
    });

    SearchHistoryModel searchHistoryModel = SearchHistoryModel();
    await searchHistoryModel.loadItems();

//    Iterable<spotify.Album> albums;
//    Iterable<spotify.Artist> artists;
//    Iterable<spotify.Track> tracks;
//    try {
//      albums = await searchHistoryModel.albumItems();
//      artists = await searchHistoryModel.artistItems();
//      tracks = await searchHistoryModel.trackItems();
//    } catch (e) {
//      // TODO Log to error reporting
//      setState(() {
//        _hasError = true;
//      });
//    }

    setState(() {
      _isBusy = false;
      _searchHistoryModel = searchHistoryModel;
//      _albums = albums;
//      _artists = artists;
//      _tracks = tracks;
    });
  }
}
