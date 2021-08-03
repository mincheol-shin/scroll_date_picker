import 'package:flutter/material.dart';

enum DatePickerLocale {
  en_us,
  ko_kr,
  fr_fr,
}

extension DatePickerLocaleExtension on DatePickerLocale {
  dynamic get month {
    switch (this) {
      case DatePickerLocale.en_us:
        return [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December'
        ];
      case DatePickerLocale.ko_kr:
        return [for (int i = 1; i <= 12; i++) i];
      case DatePickerLocale.fr_fr:
        return [
          'Janvier',
          'Février',
          'Mars',
          'Avril',
          'Mai',
          'Juin',
          'Juillet',
          'Août',
          'Septembre',
          'Octobre',
          'Novembre',
          'Décembre'
        ];
      default:
        return "";
    }
  }
}

class DatePickerConfig {
  DatePickerConfig({
    this.itemExtent = 45.0,
    this.diameterRatio = 3.0,
    this.perspective = 0.01,
    this.textStyle = const TextStyle(fontSize: 18.0, color: Colors.grey),
    this.selectedTextStyle = const TextStyle(
        fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.w500),
    this.isLoop = true,
  }) : assert(itemExtent > 0);

  /// Size of each child in the main axis
  final double itemExtent;

  /// {@macro flutter.rendering.wheelList.diameterRatio}
  final double diameterRatio;

  /// {@macro flutter.rendering.wheelList.perspective}
  final double perspective;

  /// An opaque object that determines the size, position, and rendering of selected text.
  final TextStyle selectedTextStyle;

  /// An opaque object that determines the size, position, and rendering of text.
  final TextStyle textStyle;

  /// The loop iterates on an explicit list of values
  final bool isLoop;
}

String dateFormatter(int value) {
  return value.toString().length > 1 ? value.toString() : "0$value";
}
