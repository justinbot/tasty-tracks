import 'package:flutter/material.dart';

class HeaderSearchItem extends StatelessWidget {
  const HeaderSearchItem({
    Key key,
    this.label,
  }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            label,
            style: Theme.of(context).textTheme.title,
          ),
          FlatButton(
            // TODO
            onPressed: () {},
            child: Text('See all'),
          ),
        ],
      ),
    );
  }
}
