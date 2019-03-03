import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage({
    Key key,
    this.content,
    this.isBusy,
    this.hasError,
    this.errorText,
    this.palette,
  }) : super(key: key);

  final Widget content;
  final bool isBusy;
  final bool hasError;
  final String errorText;
  final PaletteGenerator palette;

  @override
  Widget build(BuildContext context) {
    if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(errorText),
            // TODO Try again button
          ],
        ),
      );
    } else if (isBusy) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      ThemeData theme = Theme.of(context);
      Color sampledAccentColor = _sampledAccentColor();
      if (sampledAccentColor != null) {
        theme = theme.copyWith(accentColor: sampledAccentColor);
      }
      return Theme(
        data: theme,
        child: content,
      );
    }
  }

  Color _sampledAccentColor() {
    if (palette != null) {
      // Try to get a color from the palette to use as an accent
      return palette.lightVibrantColor?.color ??
          palette.vibrantColor?.color ??
          palette.lightMutedColor?.color;
    } else {
      return null;
    }
  }
}
