import 'package:flutter/material.dart';

class ColorGenerator {
  // Generate a consistent color based on the article ID
  static Color fromId(int id) {
    // Use the ID to seed a consistent color
    // This ensures the same ID always gets the same color
    final int hue = (id * 137) % 360;
    return HSLColor.fromAHSL(1.0, hue.toDouble(), 0.7, 0.5).toColor();
  }

  // Get a contrasting text color (white or black) based on background brightness
  static Color getTextColor(Color backgroundColor) {
    // Calculate relative luminance
    final double luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}
