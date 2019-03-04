import 'package:flutter/material.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage({
    Key key,
    this.errorText,
    this.onRetry,
  }) : super(key: key);

  final String errorText;
  final Function onRetry;

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [
      Text(errorText),
    ];

    if (onRetry != null) {
      items.add(OutlineButton(
        onPressed: () => onRetry(),
        child: Text('Try again'),
      ));
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: items,
          ),
        ),
      ),
    );
  }
}
