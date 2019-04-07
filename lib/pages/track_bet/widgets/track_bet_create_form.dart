import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:tasty_tracks/models/track_bet_model.dart';
import 'package:tasty_tracks/models/track_watch_model.dart';
import 'package:tasty_tracks/models/user_profile_model.dart';

class TrackBetCreateForm extends StatefulWidget {
  const TrackBetCreateForm({
    Key key,
    this.trackId,
  }) : super(key: key);

  final String trackId;

  @override
  _TrackBetCreateFormState createState() => _TrackBetCreateFormState();
}

class _TrackBetCreateFormState extends State<TrackBetCreateForm> {
  final _formKey = GlobalKey<FormState>();
  final _betAmountController = TextEditingController();
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
                children: [
                  StreamBuilder(
                    stream: userProfileModel.snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      String formattedPoints = '...';

                      if (snapshot.hasData) {
                        DocumentSnapshot userProfile =
                            snapshot.data.documents.first;

                        double points = userProfile.data['points'].toDouble();

                        NumberFormat numberFormat =
                            NumberFormat.currency(symbol: '');

                        formattedPoints = numberFormat.format(points);
                      }

                      return Text(
                        formattedPoints,
                        style: theme.textTheme.title,
                      );
                    },
                  ),
                  const SizedBox(width: 8.0),
                  Text('points available'),
                ],
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                autofocus: true,
                controller: _betAmountController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Bet amount',
                  suffixText: 'Points',
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                maxLines: 1,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter a bet amount';
                  } else if (double.tryParse(value) == null) {
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

    // TODO
    double betAmount = double.parse(_betAmountController.text);

    setState(() {
      _busy = true;
    });

    DocumentSnapshot userProfile = await userProfileModel.get();
    if (userProfile.data['points'] < betAmount) {
      setState(() {
        _busy = false;
      });

      String errorMessage = 'Insufficient points for this bet.';
      Scaffold.of(context).showSnackBar(SnackBar(content: Text(errorMessage)));
      return;
    }

    // Remove any watch
    DocumentSnapshot watch = await trackWatchModel.get(widget.trackId);
    if (watch != null) {
      watch.reference.delete();
    }

    DocumentReference bet = await trackBetModel.add(widget.trackId, betAmount);
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
