import 'package:flutter/material.dart';

class TransactionHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Center(
      child: Text(
        'No transactions to show.',
        style: theme.textTheme.caption,
      ),
    );
  }
}
