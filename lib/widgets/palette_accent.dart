import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class PaletteAccent extends StatelessWidget {
  const PaletteAccent({
    Key key,
    this.child,
    this.palette,
  }) : super(key: key);

  final Widget child;
  final PaletteGenerator palette;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    // Try to get a color from the palette to use as an accent
    if (palette != null) {
      Color sampledAccentColor = palette.lightVibrantColor?.color ??
          palette.vibrantColor?.color ??
          palette.lightMutedColor?.color;
      if (sampledAccentColor != null) {
        theme = theme.copyWith(accentColor: sampledAccentColor);
      }
    }
    return Theme(
      data: theme,
      child: child,
    );
  }
}
