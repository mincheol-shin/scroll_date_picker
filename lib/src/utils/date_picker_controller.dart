import 'package:flutter/cupertino.dart';

class DatePickerController extends FixedExtentScrollController {
  DatePickerController({
    this.year = 2021,
    this.month = 1,
    this.day = 1,
    this.minYear = 2010,
    this.maxYear = 2050,
  })  : monthController = FixedExtentScrollController(initialItem: month - 1),
        dayController = FixedExtentScrollController(initialItem: day - 1),
        assert(year >= minYear),
        super(
          initialItem: year - minYear,
        );

  /// The initial date and/or time of the picker.
  final int year;

  /// The initial date and/or time of the picker.
  final int month;

  /// The initial date and/or time of the picker.
  final int day;

  /// Minimum year that the picker can be scrolled
  final int minYear;

  /// Maximum year that the picker can be scrolled
  final int maxYear;

  /// This widget's month selection and animation state.
  final FixedExtentScrollController monthController;

  /// This widget's day selection and animation state.
  final FixedExtentScrollController dayController;

  @override
  void dispose() {
    monthController.dispose();
    dayController.dispose();

    super.dispose();
  }
}
