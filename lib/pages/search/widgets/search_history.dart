import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/models/search_history_model.dart';
import 'package:tasty_tracks/pages/search/widgets/album_search_item.dart';
import 'package:tasty_tracks/pages/search/widgets/artist_search_item.dart';
import 'package:tasty_tracks/pages/search/widgets/header_search_item.dart';
import 'package:tasty_tracks/pages/search/widgets/track_search_item.dart';

class SearchHistory extends StatelessWidget {
  const SearchHistory({
    Key key,
    this.onTapItem,
  }) : super(key: key);

  final onTapItem;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<SearchHistoryModel>(
      builder: (context, child, history) {
        return FutureBuilder(
          future: Future.wait([
            history.albumItems(),
            history.artistItems(),
            history.trackItems()
          ]),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<spotify.Album> albums = snapshot.data[0];
              List<spotify.Artist> artists = snapshot.data[1];
              List<spotify.Track> tracks = snapshot.data[2];

              ThemeData theme = Theme.of(context);

              List<Widget> combinedResultsItems = List();
              bool hasResults = false;

              combinedResultsItems.add(
                Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                    'Recent searches',
                    style: theme.textTheme.title,
                    textAlign: TextAlign.center,
                  ),
                ),
              );

              if (tracks.isNotEmpty) {
                hasResults = true;
                Iterable<Widget> trackItems =
                    tracks.map((track) => TrackSearchItem(
                          onTap: _handleSelectedItem,
                          track: track,
                        ));

                combinedResultsItems
                  ..add(HeaderSearchItem(
                    label: 'Tracks',
                  ))
                  ..addAll(trackItems);
              }

              if (artists.isNotEmpty) {
                hasResults = true;
                Iterable<Widget> artistItems =
                    artists.map((artist) => ArtistSearchItem(
                          onTap: _handleSelectedItem,
                          artist: artist,
                        ));

                combinedResultsItems
                  ..add(HeaderSearchItem(
                    label: 'Artists',
                  ))
                  ..addAll(artistItems);
              }

              if (albums.isNotEmpty) {
                hasResults = true;
                Iterable<Widget> albumItems =
                    albums.map((album) => AlbumSearchItem(
                          onTap: _handleSelectedItem,
                          album: album,
                        ));

                combinedResultsItems
                  ..add(HeaderSearchItem(
                    label: 'Albums',
                  ))
                  ..addAll(albumItems);
              }

              if (!hasResults) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        FeatherIcons.search,
                        size: 64.0,
                      ),
                      SizedBox(
                        height: 32.0,
                      ),
                      Text(
                        'Search for tracks, artists, and albums.',
                        style: theme.textTheme.subhead,
                      ),
                    ],
                  ),
                );
              } else {
                combinedResultsItems.add(
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: FlatButton(
                      onPressed: () {},
                      child: Text('Clear recent searches'),
                    ),
                  ),
                );
                return ListView(children: combinedResultsItems);
              }
            } else if (snapshot.hasError) {
              print(snapshot.error);
              return Center(
                child: Text('Error loading your recent searches :('),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
      },
    );
  }

  _handleSelectedItem(Object result) {
    onTapItem(result);
  }
}
