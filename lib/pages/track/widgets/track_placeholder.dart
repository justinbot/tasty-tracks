import 'package:flutter/material.dart';

class TrackDetailsPlaceholder extends StatelessWidget {
  const TrackDetailsPlaceholder({
    Key key,
    this.trackId,
    this.trackImageUrl,
    this.heroSuffix,
  }) : super(key: key);

  final String trackId;
  final String trackImageUrl;
  final String heroSuffix;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Widget trackImage;

    if (trackImageUrl != null) {
      trackImage = Image.network(
        trackImageUrl,
        fit: BoxFit.cover,
      );
    } else {
      trackImage = Image.asset(
        'assets/album_image_placeholder.png',
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
                    tag: 'trackImageHero-${heroSuffix ?? trackId}',
                    child: trackImage,
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
