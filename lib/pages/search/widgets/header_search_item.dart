import 'package:flutter/material.dart';

class HeaderSearchItem extends StatelessWidget {
  const HeaderSearchItem({
    Key key,
    this.label,
    this.trailing,
  }) : super(key: key);

  final String label;
  final Widget trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.title,
          ),
          trailing ?? Container(),
        ],
      ),
    );
  }
}
