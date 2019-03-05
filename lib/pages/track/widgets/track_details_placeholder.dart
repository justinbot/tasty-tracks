import 'package:flutter/material.dart';

class TrackDetailsPlaceholder extends StatelessWidget {
  const TrackDetailsPlaceholder({
    Key key,
    this.trackId,
  }) : super(key: key);

  final String trackId;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    Widget appBar = AppBar(
      backgroundColor: theme.canvasColor,
    );

    Widget albumImage = Hero(
      tag: 'trackImageHero-${trackId}',
      child: Image.asset(
        'assets/album_image_placeholder.png',
        fit: BoxFit.cover,
      ),
    );

    Widget header = Container(
      padding: EdgeInsets.symmetric(horizontal: 64.0, vertical: 32.0),
      child: Column(
        children: <Widget>[
          albumImage,
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
