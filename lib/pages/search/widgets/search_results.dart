import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/pages/search/widgets/album_search_item.dart';
import 'package:tasty_tracks/pages/search/widgets/artist_search_item.dart';
import 'package:tasty_tracks/pages/search/widgets/header_search_item.dart';
import 'package:tasty_tracks/pages/search/widgets/track_search_item.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({
    Key key,
    this.onSelectedItem,
    this.tracks,
    this.artists,
    this.albums,
  }) : super(key: key);

  final onSelectedItem;
  final List<spotify.Track> tracks;
  final List<spotify.Artist> artists;
  final List<spotify.AlbumSimple> albums;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    List<Widget> combinedResultsItems = List();
    bool hasResults = false;

    if (tracks.isNotEmpty) {
      hasResults = true;
      Iterable<Widget> trackItems = tracks.map((track) => TrackSearchItem(
            onTap: _handleSelectedItem,
            track: track,
          ));

      combinedResultsItems
        ..add(HeaderSearchItem(
          label: 'Tracks',
          trailing: FlatButton(
            child: Text('See all'),
            onPressed: () {
              // TODO
            },
          ),
        ))
        ..addAll(trackItems);
    }

    if (artists.isNotEmpty) {
      hasResults = true;
      Iterable<Widget> artistItems = artists.map((artist) => ArtistSearchItem(
            onTap: _handleSelectedItem,
            artist: artist,
          ));

      combinedResultsItems
        ..add(HeaderSearchItem(
          label: 'Artists',
          trailing: FlatButton(
            child: Text('See all'),
            onPressed: () {
              // TODO
            },
          ),
        ))
        ..addAll(artistItems);
    }

    if (albums.isNotEmpty) {
      hasResults = true;
      Iterable<Widget> albumItems = albums.map((album) => AlbumSearchItem(
            onTap: _handleSelectedItem,
            album: album,
          ));

      combinedResultsItems
        ..add(HeaderSearchItem(
          label: 'Albums',
          trailing: FlatButton(
            child: Text('See all'),
            onPressed: () {
              // TODO
            },
          ),
        ))
        ..addAll(albumItems);
    }

    if (!hasResults) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              FeatherIcons.flag,
              size: 64.0,
            ),
            SizedBox(
              height: 32.0,
            ),
            Text(
              'No results found for your search :(',
              style: theme.textTheme.subhead,
            ),
          ],
        ),
      );
    } else {
      return ListView(children: combinedResultsItems);
    }
  }

  _handleSelectedItem(Object result) {
    onSelectedItem(result);
  }
}
