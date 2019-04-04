import 'package:flutter/material.dart';

class TrackBetCreateForm extends StatefulWidget {
  @override
  _TrackBetCreateFormState createState() => _TrackBetCreateFormState();
}

class _TrackBetCreateFormState extends State<TrackBetCreateForm> {
  final _betAmountController = TextEditingController();
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Form(
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
              }
            },
          ),
          const SizedBox(height: 16.0),
          RaisedButton(
            child: Text('Place bet'),
            color: theme.accentColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(64.0),
            ),
            onPressed: _busy ? null : _placeBet,
          ),
        ],
      ),
    );
  }

  _placeBet() async {
    // TODO Show bet dialog
  }
}
