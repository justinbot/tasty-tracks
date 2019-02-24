import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/spotify_api.dart';

class TrackSearchDelegate extends SearchDelegate {
  // TODO Implement searching as user types, with debouncing
  // buildSuggestions

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(FeatherIcons.x),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(FeatherIcons.arrowLeft),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO Handle empty query
    // TODO cache results, only fetch if query changes
    // Get search results
    print('boutta API query!!!!!!!!!!!!!!!!!!!!!!!!!!');
    Stream<List<spotify.Page<Object>>> searchResults = spotifyApi.search
        .get(
          query,
          [
            spotify.SearchType.track,
            spotify.SearchType.artist,
            spotify.SearchType.album,
          ],
        )
        .first(5)
        .asStream();

    return StreamBuilder(
      stream: searchResults,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error getting your results :('),
          );
        }

        if (snapshot.data.isEmpty) {
          return Center(
            child: Text(
              'No results found :(',
              style: Theme.of(context).textTheme.title,
            ),
          );
        }

        List<spotify.TrackSimple> trackResults = List<spotify.TrackSimple>();
        List<spotify.Artist> artistResults = List<spotify.Artist>();
        List<spotify.AlbumSimple> albumResults = List<spotify.AlbumSimple>();

        // Separate into lists of each type of result
        snapshot.data.forEach((spotify.Page<Object> page) {
          artistResults.addAll(page.items.whereType<spotify.Artist>());
          albumResults.addAll(page.items.whereType<spotify.AlbumSimple>());
          trackResults.addAll(page.items.whereType<spotify.TrackSimple>());
        });

        // TODO Handle empty results
        // TODO Augment track results
        // TODO Add transitions to detail pages
        List<Widget> trackResultsItems = trackResults
            .map((track) => _trackSearchItem(context, track))
            .toList();
        List<Widget> artistResultsItems = artistResults
            .map((artist) => _artistSearchItem(context, artist))
            .toList();
        List<Widget> albumResultsItems = albumResults
            .map((album) => _albumSearchItem(context, album))
            .toList();

        List<Widget> combinedResultsItems = List<Widget>();
        combinedResultsItems.add(Text('Tracks'));
        combinedResultsItems.addAll(trackResultsItems);
        combinedResultsItems.add(Text('Artist'));
        combinedResultsItems.addAll(artistResultsItems);
        combinedResultsItems.add(Text('Albums'));
        combinedResultsItems.addAll(albumResultsItems);

        return ListView(children: combinedResultsItems);
      },
    );
  }

  Widget _trackSearchItem(BuildContext context, spotify.TrackSimple track) {
    CircleAvatar trackAvatar = CircleAvatar(
      backgroundColor: Colors.blueGrey,
//      backgroundImage: NetworkImage(track.album.images.first.url),
    );
    String artistNames = track.artists.map((artist) => artist.name).join(', ');

    return ListTile(
      leading: trackAvatar,
      title: Text(
        track.name,
        style: Theme.of(context).textTheme.subhead,
      ),
      // TODO Display Explicit and other data in subtitle
      subtitle: Text(artistNames),
      onTap: () {
        close(context, track);
      },
    );
  }

  Widget _artistSearchItem(BuildContext context, spotify.Artist artist) {
    CircleAvatar albumAvatar = CircleAvatar(
      backgroundImage: NetworkImage(artist.images.first.url),
    );

    return ListTile(
      leading: albumAvatar,
      title: Text(
        artist.name,
        style: Theme.of(context).textTheme.subhead,
      ),
      subtitle: Text('${artist.popularity}'),
      onTap: () {
        close(context, artist);
      },
    );
  }

  Widget _albumSearchItem(BuildContext context, spotify.AlbumSimple album) {
    CircleAvatar albumAvatar = CircleAvatar(
      backgroundImage: NetworkImage(album.images.first.url),
    );
    String artistNames = album.artists.map((artist) => artist.name).join(', ');

    return ListTile(
      leading: albumAvatar,
      title: Text(
        album.name,
        style: Theme.of(context).textTheme.subhead,
      ),
      subtitle: Text(artistNames),
      onTap: () {
        close(context, album);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // return buildResults(context);
    return Center(child: Text('Suggestions go here'));
  }
}
