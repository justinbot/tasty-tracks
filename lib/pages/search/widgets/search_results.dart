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
    this.onTap,
    this.tracks,
    this.artists,
    this.albums,
  }) : super(key: key);

  final onTap;
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
            onTap: onTap,
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
      Iterable<Widget> artistItems = artists.map((artist) => ArtistSearchItem(
            onTap: onTap,
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
      Iterable<Widget> albumItems = albums.map((album) => AlbumSearchItem(
            onTap: onTap,
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
              FeatherIcons.flag,
              size: 64.0,
            ),
            SizedBox(height: 32.0,),
            Text('No results found for your search :(', style: theme.textTheme.subhead,),
          ],
        ),
      );
    } else {
      return ListView(children: combinedResultsItems);
    }
  }
}
