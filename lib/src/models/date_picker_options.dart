import 'package:flutter/material.dart';

class DatePickerOptions {
  const DatePickerOptions({
    this.itemExtent = 30.0,
    this.diameterRatio = 3.0,
    this.perspective = 0.01,
    this.isLoop = true,
    this.textStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
  });

  /// Size of each child in the main axis
  final double itemExtent;

  /// {@macro flutter.rendering.wheelList.diameterRatio}
  final double diameterRatio;

  /// {@macro flutter.rendering.wheelList.perspective}
  final double perspective;

  /// The loop iterates on an explicit list of values
  final bool isLoop;

  /// An immutable style describing how to format and paint text.
  final TextStyle textStyle;
}
