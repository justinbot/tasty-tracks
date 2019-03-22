import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:tasty_tracks/constants/theme.dart';
import 'package:tasty_tracks/pages/album/album.dart';
import 'package:tasty_tracks/pages/artist/artist.dart';
import 'package:tasty_tracks/pages/auth/landing.dart';
import 'package:tasty_tracks/pages/auth/sign_in.dart';
import 'package:tasty_tracks/pages/auth/sign_up.dart';
import 'package:tasty_tracks/pages/home/home.dart';
import 'package:tasty_tracks/pages/navigation.dart';
import 'package:tasty_tracks/pages/track/track.dart';

class TastyTracksApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: tastyTracksTheme,
      title: 'Tasty Tracks',
      onGenerateRoute: _handleRoute,
      routes: {
        LandingPage.routeName: (BuildContext context) => LandingPage(),
        NavigationPage.routeName: (BuildContext context) => NavigationPage(),
        SignInPage.routeName: (BuildContext context) => SignInPage(),
        SignUpPage.routeName: (BuildContext context) => SignUpPage(),
        HomePage.routeName: (BuildContext context) => HomePage(),
      },
      onUnknownRoute: _onUnknownRoute,
    );
  }
}

Route<dynamic> _handleRoute(RouteSettings settings) {
  // TODO Use classes for arguments objects
  final String path = settings.name;
  final Map<String, String> arguments = settings.arguments ?? Map();

  if (path.startsWith(TrackPage.routeName)) {
    /// TrackPage
    /// arguments:
    /// - track_id
    /// - track_image_url (optional)
    /// - hero_suffix (optional)
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) => TrackPage(
            trackId: arguments['track_id'],
            trackImageUrl: arguments['image_url'],
            heroSuffix: arguments['hero_suffix'],
          ),
    );
  } else if (path.startsWith(AlbumPage.routeName)) {
    /// AlbumPage
    /// arguments:
    /// - album_id
    /// - album_image_url (optional)
    /// - hero_suffix (optional)
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) => AlbumPage(
            albumId: arguments['album_id'],
          ),
    );
  } else if (path.startsWith(ArtistPage.routeName)) {
    /// ArtistPage
    /// arguments:
    /// - artist_id
    /// - artist_image_url (optional)
    /// - hero_suffix (optional)
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) => ArtistPage(
            artistId: arguments['artist_id'],
          ),
    );
  } else {
    return null;
  }
}

Route<dynamic> _onUnknownRoute(RouteSettings settings) {
  // TODO Log unknown route to error reporting
  // Navigate to sign in page
  return MaterialPageRoute(
    settings: settings,
    builder: (BuildContext context) => SignInPage(),
    fullscreenDialog: true,
  );
}
