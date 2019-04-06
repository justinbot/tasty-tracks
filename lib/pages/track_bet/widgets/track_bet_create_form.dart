import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import 'package:tasty_tracks/models/track_bet_model.dart';
import 'package:tasty_tracks/models/track_watch_model.dart';

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

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('999,999,999 points available'),
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
          const SizedBox(height: 16.0),
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
                    onPressed: _busy ? null : () {
                      _placeBet(context, trackBetModel, trackWatchModel)
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  _placeBet(BuildContext context, TrackBetModel trackBetModel,
      TrackWatchModel trackWatchModel) async {
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
