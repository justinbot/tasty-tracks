import 'package:flutter/material.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';

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
        flexibleSpace: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: RaisedButton(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FeatherIcons.search,
                    size: 18.0,
                  ),
                  Text('Search'),
                ],
              ),
              color: Colors.white,
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
            ),
          ),
        ),
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
