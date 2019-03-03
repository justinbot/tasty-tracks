import 'package:flutter/material.dart';
import 'package:spotify/spotify_io.dart' as spotify;

class AlbumImage extends StatelessWidget {
  const AlbumImage({
    Key key,
    this.album,
    this.diameter,
  }) : super(key: key);

  final spotify.AlbumSimple album;
  final double diameter;

  final String placeholderAsset = 'assets/album_cover_placeholder.png';

  @override
  Widget build(BuildContext context) {
    if (album.images.isNotEmpty) {
      return FadeInImage.assetNetwork(
        placeholder: placeholderAsset,
        image: album.images.first.url,
        fit: BoxFit.cover,
        width: diameter,
        height: diameter,
      );
    } else {
      return Image.asset(
        placeholderAsset,
        fit: BoxFit.cover,
        width: diameter,
        height: diameter,
      );
    }
  }
}
