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
    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextFormField(
            controller: _betAmountController,
            decoration: const InputDecoration(
              labelText: 'points',
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter a bet amount';
              }
            },
          ),
          RaisedButton(
            onPressed: _busy ? null : _placeBet,
            child: Text('Place bet'),
          ),
        ],
      ),
    );
  }

  _placeBet() async {}
}
