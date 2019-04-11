import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:spotify/spotify_io.dart' as spotify;

import 'package:tasty_tracks/models/track_bet_model.dart';
import 'package:tasty_tracks/models/track_watch_model.dart';
import 'package:tasty_tracks/models/user_profile_model.dart';

class TrackBetCreateForm extends StatefulWidget {
  const TrackBetCreateForm({
    Key key,
    this.track,
  }) : super(key: key);

  final spotify.Track track;

  @override
  _TrackBetCreateFormState createState() => _TrackBetCreateFormState();
}

class _TrackBetCreateFormState extends State<TrackBetCreateForm> {
  final _formKey = GlobalKey<FormState>();
  final _wagerController = TextEditingController();
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return ScopedModelDescendant<UserProfileModel>(
      builder: (context, child, userProfileModel) {
        return Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(FeatherIcons.star),
                  const SizedBox(width: 4.0),
                  StreamBuilder(
                    stream: userProfileModel.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      String formattedBalance = '...';

                      if (snapshot.hasData) {
                        DocumentSnapshot userProfile =
                            snapshot.data.documents.first;

                        double balance = userProfile.data['balance'].toDouble();

                        NumberFormat numberFormat =
                            NumberFormat.currency(symbol: '');

                        formattedBalance = numberFormat.format(balance);
                      }

                      return Text(
                        formattedBalance,
                        style: theme.textTheme.title,
                      );
                    },
                  ),
                  const SizedBox(width: 8.0),
                  Text('available'),
                ],
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                autofocus: true,
                controller: _wagerController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Bet amount',
                  suffixIcon: Icon(FeatherIcons.star),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                maxLines: 1,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a bet amount';
                  } else if (double.tryParse(value) == null) {
                    return 'Invalid bet amount';
                  } else if (!(double.tryParse(value) > 0)) {
                    return 'Invalid bet amount';
                  }
                },
              ),
              const SizedBox(height: 24.0),
              ScopedModelDescendant<TrackBetModel>(
                builder: (context, child, trackBetModel) {
                  return ScopedModelDescendant<TrackWatchModel>(
                    builder: (context, child, trackWatchModel) {
                      return RaisedButton(
                        child: Text('Place bet'),
                        color: theme.accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(64.0),
                        ),
                        onPressed: _busy
                            ? null
                            : () {
                                _placeBet(context, trackBetModel,
                                    trackWatchModel, userProfileModel);
                              },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  _placeBet(
      BuildContext context,
      TrackBetModel trackBetModel,
      TrackWatchModel trackWatchModel,
      UserProfileModel userProfileModel) async {
    // Dismiss keyboard
    FocusScope.of(context).requestFocus(FocusNode());

    bool valid = _formKey.currentState.validate();
    if (!valid) {
      return;
    }

    double wager = double.parse(_wagerController.text);

    setState(() {
      _busy = true;
    });

    DocumentSnapshot userProfile = await userProfileModel.get();
    if (userProfile.data['balance'] < wager) {
      setState(() {
        _busy = false;
      });

      String errorMessage = 'Insufficient balance for this bet.';
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      return;
    }

    // Remove any watch
    DocumentSnapshot watch = await trackWatchModel.get(widget.track.id);
    if (watch != null) {
      watch.reference.delete();
    }

    DocumentReference bet = await trackBetModel.add(
        trackId: widget.track.id,
        wager: wager,
        popularity: widget.track.popularity);
    if (bet == null) {
      // Failed to create bet
      setState(() {
        _busy = false;
      });

      String errorMessage = "Couldn't place bet.";
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
    } else {
      Navigator.of(context).pop(bet);
    }
  }
}
