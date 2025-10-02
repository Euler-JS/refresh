import 'dart:math';
import 'package:flutter/material.dart';

// This class helps manage responsive font sizes across different device sizes
class ResponsiveText {
  static double getSize(BuildContext context, double size) {
    double baseWidth = 375.0; // Base width (iPhone X)
    double screenWidth = MediaQuery.of(context).size.width;
    double scaleFactor = screenWidth / baseWidth;
    double calculatedSize = size * scaleFactor;
    
    // Cap the min and max font sizes to prevent too small or too large text
    return max(size * 0.8, min(calculatedSize, size * 1.2));
  }
  
  // Helper method to quickly get responsive text style
  static TextStyle style({
    required BuildContext context,
    required double fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    TextDecoration? decoration,
    List<Shadow>? shadows,
    double? letterSpacing,
  }) {
    return TextStyle(
      fontSize: getSize(context, fontSize),
      fontWeight: fontWeight,
      color: color,
      height: height,
      decoration: decoration,
      shadows: shadows,
      letterSpacing: letterSpacing,
    );
  }
}