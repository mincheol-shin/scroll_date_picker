import 'package:flutter/material.dart';

class DatePickerScrollViewOptions {
  const DatePickerScrollViewOptions({
    this.year = const ScrollViewDetailOptions(),
    this.month = const ScrollViewDetailOptions(),
    this.day = const ScrollViewDetailOptions(),
  });

  final ScrollViewDetailOptions year;
  final ScrollViewDetailOptions month;
  final ScrollViewDetailOptions day;
}

class ScrollViewDetailOptions {
  const ScrollViewDetailOptions({
    this.label = '',
    this.alignment = Alignment.centerLeft,
    this.margin,
    this.selectedTextStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    this.textStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
  });

  /// The text printed next to the year, month, and day.
  final String label;

  /// The year, month, and day text alignment method.
  final Alignment alignment;

  /// The amount of space that can be added to the year, month, and day.
  final EdgeInsets? margin;

  /// An immutable style describing how to format and paint text.
  final TextStyle textStyle;

  /// An invariant style that specifies the selected text format and explains how to draw it.
  final TextStyle selectedTextStyle;
}
