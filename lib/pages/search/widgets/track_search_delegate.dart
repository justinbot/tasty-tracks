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
    Stream<List<spotify.Page<Object>>> searchResults = spotifyApi.search
        .get(query, [spotify.SearchType.track])
        .first(20)
        .asStream();

    return StreamBuilder(
      stream: searchResults,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error getting your results :('));
        }

        if (snapshot.data.isEmpty || snapshot.data.first.items.isEmpty) {
          return Center(
            child: Text('No results found :(',
                style: Theme.of(context).textTheme.title),
          );
        }

        spotify.Page<Object> page = snapshot.data.first;
        List<Object> results = page.items.toList();
        List<spotify.TrackSimple> trackResults =
            results.whereType<spotify.TrackSimple>().toList();

        // Get full tracks
        var fullTracks =
            spotifyApi.tracks.list(trackResults.map((t) => t.id)).asStream();

        return StreamBuilder(
            stream: fullTracks,
            builder: (context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(child: Text('Error getting your results :('));
              }

              List<spotify.Track> tracksList = snapshot.data.toList();
              return ListView.builder(
                shrinkWrap: true,
                itemCount: tracksList.length,
                itemBuilder: (context, index) {
                  var item = tracksList[index];
                  return _trackListItem(context, item);
                },
              );
            });
      },
    );
  }

  Widget _trackListItem(BuildContext context, spotify.Track track) {
    CircleAvatar trackAvatar = CircleAvatar(
      backgroundImage: NetworkImage(track.album.images.first.url),
    );
    String artistNames = track.artists.map((artist) => artist.name).join(', ');

    return ListTile(
      leading: trackAvatar,
      title: Text(track.name, style: Theme.of(context).textTheme.subhead),
      // TODO Display Explicit and other data in subtitle
      subtitle: Text(artistNames),
      onTap: () {
        close(context, track);
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // return buildResults(context);
    return Center(child: Text('Suggestions go here'));
  }
}
