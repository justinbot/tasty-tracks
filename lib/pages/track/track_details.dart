import 'package:flutter/material.dart';

class TrackDetailsPage extends StatefulWidget {
  static final String routeName = '/track-details';
  final String trackId;

  const TrackDetailsPage({Key key, this.trackId}) : super(key: key);

  @override
  _TrackDetailsPageState createState() => _TrackDetailsPageState();
}

class _TrackDetailsPageState extends State<TrackDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TODO'),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Text('Track details - ${widget.trackId}'),
          ],
        ),
      ),
    );
  }
}
