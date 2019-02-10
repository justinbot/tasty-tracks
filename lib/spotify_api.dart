import 'package:spotify/spotify_io.dart';

import 'package:tasty_tracks/config.dart';

SpotifyApiCredentials credentials =
    SpotifyApiCredentials(spotifyApiClientId, spotifyApiClientSecret);
SpotifyApi spotifyApi = SpotifyApi(credentials);
