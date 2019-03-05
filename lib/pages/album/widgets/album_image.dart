import 'package:flutter/material.dart';
import 'package:spotify/spotify_io.dart' as spotify;

class AlbumImage extends StatelessWidget {
  const AlbumImage({
    Key key,
    this.album,
    this.diameter,
    this.rounded = false,
  }) : super(key: key);

  final spotify.AlbumSimple album;
  final double diameter;
  final bool rounded;

  final String placeholderAsset = 'assets/album_image_placeholder.png';

  @override
  Widget build(BuildContext context) {
    Widget albumImage;
    if (album.images.isNotEmpty) {
      albumImage = FadeInImage.assetNetwork(
        placeholder: placeholderAsset,
        image: album.images.first.url,
        fit: BoxFit.cover,
        fadeOutDuration: const Duration(milliseconds: 100),
        fadeInDuration: const Duration(milliseconds: 300),
        width: diameter,
        height: diameter,
      );
    } else {
      albumImage = Image.asset(
        placeholderAsset,
        fit: BoxFit.cover,
        width: diameter,
        height: diameter,
      );
    }

    if (rounded) {
      return ClipOval(
        child: albumImage,
      );
    } else {
      return albumImage;
    }
  }
}
