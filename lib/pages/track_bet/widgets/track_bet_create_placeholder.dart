import 'package:flutter/material.dart';

class TrackBetCreatePlaceholder extends StatelessWidget {
  const TrackBetCreatePlaceholder({
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
              padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 32.0),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Hero(
                          tag: 'trackImageHero-${heroSuffix ?? trackId}',
                          child: trackImage,
                        ),
                      ),
                      SizedBox(width: 32.0),
                      Expanded(
                        flex: 2,
                        child: Container(),
                      ),
                    ],
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
