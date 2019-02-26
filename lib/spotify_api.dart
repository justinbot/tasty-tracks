import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/constants/config.dart';

spotify.SpotifyApiCredentials credentials =
    spotify.SpotifyApiCredentials(spotifyApiClientId, spotifyApiClientSecret);
spotify.SpotifyApi spotifyApi = spotify.SpotifyApi(credentials);
