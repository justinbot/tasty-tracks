import 'package:flutter/material.dart';
import 'package:spotify/spotify_io.dart';

import 'package:tasty_tracks/spotify_api.dart';

class SearchPage extends StatefulWidget {
  static final String routeName = '/search';
  final String pageTitle = 'Search';

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search tracks'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('TODO Recent searches'),
          ],
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate {
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
    var searchResults =
        spotifyApi.search.get(query, [SearchType.track]).first(20).asStream();

    return Column(
      children: <Widget>[
        StreamBuilder(
          stream: searchResults,
          builder: (context, AsyncSnapshot<List<Page<Object>>> snapshot) {
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
                Page<Object> page = snapshot.data.first;
                List<Object> results = page.items.toList();
                return Expanded(
                    child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    var item = results[index];
                    if (item is TrackSimple) {
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

  Widget _trackListItem(BuildContext context, TrackSimple track) {
    // TODO Use album art for avatar
    CircleAvatar trackAvatar = CircleAvatar(
      backgroundColor: Colors.brown.shade800,
    );

    return ListTile(
      leading: trackAvatar,
      title: Text(track.name, style: Theme.of(context).textTheme.subhead),
      // TODO Display Explicit and other data in subtitle
      subtitle: Text(track.artists.first.name),
      onTap: () {
        // TODO Navigate to track details page
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
  }
}
