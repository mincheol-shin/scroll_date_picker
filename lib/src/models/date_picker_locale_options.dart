import 'package:flutter/material.dart';

class DatePickerLocaleOptions {
  const DatePickerLocaleOptions({
    this.yearWidth = 70,
    this.monthWidth = 70,
    this.dayWidth= 70,
    this.yearLabel = "",
    this.monthLabel = "",
    this.dayLabel = "",
    this.yearAlignment = Alignment.center,
    this.monthAlignment = Alignment.center,
    this.dayAlignment = Alignment.center,
  });

  final double yearWidth;
  final double monthWidth;
  final double dayWidth;
  final String yearLabel;
  final String monthLabel;
  final String dayLabel;
  final Alignment yearAlignment;
  final Alignment monthAlignment;
  final Alignment dayAlignment;
}
