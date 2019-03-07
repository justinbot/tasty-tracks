import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

ThemeData themeWithPalette(ThemeData theme, PaletteGenerator palette) {
  // TODO Use theme constructor with sampled colors
  if (palette != null) {
    // Try to get a color from the palette to use as an accent
    Color sampledAccentColor = palette.lightVibrantColor?.color ??
        palette.vibrantColor?.color ??
        palette.lightMutedColor?.color;
    if (sampledAccentColor != null) {
      theme = theme.copyWith(accentColor: sampledAccentColor);
    }
  }

  return theme;
}
