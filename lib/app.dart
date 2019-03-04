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
  // TODO Use route arguments functionality
  // See: https://github.com/flutter/flutter/issues/6225
  final String path = settings.name;
  final List<String> uri = settings.name.split('/');
  final List<String> args = uri.last.split(':');

  if (path.startsWith(TrackPage.routeName)) {
    String trackId = args[1];
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) => TrackPage(
            trackId: trackId,
          ),
    );
  } else if (path.startsWith(AlbumPage.routeName)) {
    String albumId = args[1];
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) => AlbumPage(
            albumId: albumId,
          ),
    );
  } else if (path.startsWith(ArtistPage.routeName)) {
    String artistId = args[1];
    return MaterialPageRoute(
      settings: settings,
      builder: (BuildContext context) => ArtistPage(
            artistId: artistId,
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
