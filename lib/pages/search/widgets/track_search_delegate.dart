import 'package:flutter/material.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/spotify_api.dart';

class TrackSearchDelegate extends SearchDelegate {
  // TODO Implement searching as user types, with debouncing

  @override
  ThemeData appBarTheme(BuildContext context) {
    return Theme.of(context);
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO cache results, only fetch if query changes
    var searchResults = spotifyApi.search
        .get(query, [spotify.SearchType.track])
        .first(20)
        .asStream();

    return Column(
      children: <Widget>[
        StreamBuilder(
          stream: searchResults,
          builder:
              (context, AsyncSnapshot<List<spotify.Page<Object>>> snapshot) {
            if (!snapshot.hasData) {
              return Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Center(child: CircularProgressIndicator()),
                ],
              ));
            } else if (snapshot.hasError) {
              return Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('An error occured while searching :('),
                ],
              ));
            } else {
              // TODO Handle multiple pages
              if (snapshot.data.isEmpty || snapshot.data.first.items.isEmpty) {
                return Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('No results found :(',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.title),
                  ],
                ));
              } else {
                spotify.Page<Object> page = snapshot.data.first;
                List<Object> results = page.items.toList();
                return Expanded(
                    child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    var item = results[index];
                    if (item is spotify.TrackSimple) {
                      return _trackListItem(context, item);
                    }
                  },
                ));
              }
            }
          },
        ),
      ],
    );
  }

  Widget _trackListItem(BuildContext context, spotify.TrackSimple track) {
    // TODO Use album art for avatar
    CircleAvatar trackAvatar = CircleAvatar(
      backgroundColor: Colors.brown.shade800,
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
    return Column();
  }
}
