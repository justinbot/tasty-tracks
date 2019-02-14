import 'package:flutter/material.dart';

import 'package:tasty_tracks/pages/track/track_details.dart';
import 'package:tasty_tracks/pages/search/widgets/track_search_delegate.dart';

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
              showSearch(context: context, delegate: TrackSearchDelegate())
                  .then((selectedTrack) {
                if (selectedTrack != null) {
                  // Navigate to track details page
                  Navigator.of(context).pushNamed(
                      TrackDetailsPage.routeName + ':${selectedTrack.id}');
                }
              });
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
