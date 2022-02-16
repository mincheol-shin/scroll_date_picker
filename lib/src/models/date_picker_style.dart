import 'package:flutter/material.dart';

class DatePickerStyle {
  const DatePickerStyle({
    this.selectedTextStyle = const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    this.textStyle = const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
  });

  /// An immutable style describing how to format and paint text.
  final TextStyle textStyle;

  /// An invariant style that specifies the selected text format and explains how to draw it.
  final TextStyle selectedTextStyle;
}
