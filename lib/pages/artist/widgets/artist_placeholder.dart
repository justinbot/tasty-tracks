import 'package:flutter/material.dart';

class ArtistPlaceholder extends StatelessWidget {
  const ArtistPlaceholder({
    Key key,
    this.artistId,
    this.artistImageUrl,
    this.heroSuffix,
  }) : super(key: key);

  final String artistId;
  final String artistImageUrl;
  final String heroSuffix;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Widget artistImage;

    if (artistImageUrl != null) {
      artistImage = Image.network(
        artistImageUrl,
        fit: BoxFit.cover,
      );
    } else {
      artistImage = Image.asset(
        'assets/artist_image_placeholder.png',
        fit: BoxFit.cover,
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.canvasColor,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 64.0, vertical: 32.0),
              child: Column(
                children: [
                  Hero(
                    tag: 'artistImageHero-${heroSuffix ?? artistId}',
                    child: artistImage,
                  ),
                ],
              ),
            ),
            Center(
              heightFactor: 4.0,
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      ),
    );
  }
}
