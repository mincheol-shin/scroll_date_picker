import 'package:flutter/material.dart';

class DatePickerLocaleOptions {
  const DatePickerLocaleOptions({
    this.yearWidth = 70,
    this.monthWidth = 70,
    this.dayWidth = 70,
    this.yearLabel = "",
    this.monthLabel = "",
    this.dayLabel = "",
    this.yearAlignment = Alignment.center,
    this.monthAlignment = Alignment.center,
    this.dayAlignment = Alignment.center,
  });

  /// If non-null, requires the child to have exactly this Width.
  final double yearWidth;

  /// If non-null, requires the child to have exactly this Width.
  final double monthWidth;

  /// If non-null, requires the child to have exactly this Width.
  final double dayWidth;

  /// Text that is printed next to the year.
  final String yearLabel;

  /// Text that is printed next to the month.
  final String monthLabel;

  /// Text that is printed next to the day.
  final String dayLabel;

  /// It's a year text sorting method.
  final Alignment yearAlignment;

  /// It's a month text sorting method.
  final Alignment monthAlignment;

  /// It's a day text sorting method.
  final Alignment dayAlignment;
}
