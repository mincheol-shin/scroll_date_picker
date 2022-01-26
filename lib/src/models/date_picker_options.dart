import 'package:flutter/material.dart';

class DatePickerOptions {
  const DatePickerOptions({
    this.itemExtent = 30.0,
    this.diameterRatio = 3.0,
    this.perspective = 0.01,
    this.isLoop = true,
    this.selectedTextStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    this.textStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
    this.indicator,
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

  final TextStyle selectedTextStyle;
  final Widget? indicator;
}
