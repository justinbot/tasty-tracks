import 'package:spotify/spotify_io.dart';

// TODO Load from config
String clientId = '';
String clientSecret = '';
SpotifyApiCredentials credentials =
SpotifyApiCredentials(clientId, clientSecret);
SpotifyApi spotifyApi = SpotifyApi(credentials);
