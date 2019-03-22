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

    Widget appBar = AppBar(
      backgroundColor: theme.canvasColor,
    );

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

    Widget header = Container(
      padding: EdgeInsets.symmetric(horizontal: 64.0, vertical: 16.0),
      child: Column(
        children: <Widget>[
          Hero(
            tag: 'trackImageHero-${heroSuffix ?? trackId}',
            child: trackImage,
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            header,
          ],
        ),
      ),
    );
  }
}
