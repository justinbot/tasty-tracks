import 'package:flutter/material.dart';

import 'package:tasty_tracks/constants/theme.dart';
import 'package:tasty_tracks/pages/album/album.dart';
import 'package:tasty_tracks/pages/artist/artist.dart';
import 'package:tasty_tracks/pages/auth/landing.dart';
import 'package:tasty_tracks/pages/auth/sign_in.dart';
import 'package:tasty_tracks/pages/auth/sign_up.dart';
import 'package:tasty_tracks/pages/leaderboard/leaderboard.dart';
import 'package:tasty_tracks/pages/navigation.dart';
import 'package:tasty_tracks/pages/settings/settings.dart';
import 'package:tasty_tracks/pages/track/track.dart';
import 'package:tasty_tracks/pages/track_bet/track_bet_create.dart';
import 'package:tasty_tracks/pages/user_profile/onboard.dart';
import 'package:tasty_tracks/pages/user_profile/user_profile_edit.dart';

class TastyTracksApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: tastyTracksTheme,
      title: 'Tasty Tracks',
      onGenerateRoute: _handleRoute,
      routes: {
        LandingPage.routeName: (BuildContext context) => LandingPage(),
        LeaderboardPage.routeName: (BuildContext context) => LeaderboardPage(),
        NavigationPage.routeName: (BuildContext context) => NavigationPage(),
        OnboardPage.routeName: (BuildContext context) => OnboardPage(),
        SettingsPage.routeName: (BuildContext context) => SettingsPage(),
        SignInPage.routeName: (BuildContext context) => SignInPage(),
        SignUpPage.routeName: (BuildContext context) => SignUpPage(),
        UserProfileEditPage.routeName: (BuildContext context) =>
            UserProfileEditPage(),
      },
      onUnknownRoute: _onUnknownRoute,
    );
  }
}

Route<dynamic> _handleRoute(RouteSettings settings) {
  // TODO Use classes for arguments objects
  final String path = settings.name;
  final Map<String, String> arguments = settings.arguments ?? Map();

  switch (path) {

    /// arguments:
    /// - track_id
    /// - track_image_url (optional)
    /// - hero_suffix (optional)
    case TrackPage.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => TrackPage(
              trackId: arguments['track_id'],
              trackImageUrl: arguments['track_image_url'],
              heroSuffix: arguments['hero_suffix'],
            ),
      );

    /// arguments:
    /// - album_id
    /// - album_image_url (optional)
    /// - hero_suffix (optional)
    case AlbumPage.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => AlbumPage(
              albumId: arguments['album_id'],
              albumImageUrl: arguments['album_image_url'],
              heroSuffix: arguments['hero_suffix'],
            ),
      );

    /// arguments:
    /// - artist_id
    /// - artist_image_url (optional)
    /// - hero_suffix (optional)
    case ArtistPage.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => ArtistPage(
              artistId: arguments['artist_id'],
              artistImageUrl: arguments['artist_image_url'],
              heroSuffix: arguments['hero_suffix'],
            ),
      );

    case TrackBetCreate.routeName:
      return MaterialPageRoute(
        settings: settings,
        builder: (BuildContext context) => TrackBetCreate(
              trackId: arguments['track_id'],
            ),
      );

    default:
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
