import 'package:flutter/cupertino.dart';

class DatePickerController extends FixedExtentScrollController {
  DatePickerController({
    required this.initialDateTime,
    this.minYear = 2010,
    this.maxYear = 2050,
  })  : monthController =
            FixedExtentScrollController(initialItem: initialDateTime.month - 1),
        dayController =
            FixedExtentScrollController(initialItem: initialDateTime.day - 1),
        assert(initialDateTime.year >= minYear),
        super(
          initialItem: initialDateTime.year - minYear,
        );

  /// Minimum year that the picker can be scrolled
  final int minYear;

  /// Maximum year that the picker can be scrolled
  final int maxYear;

  /// This widget's month selection and animation state.
  final FixedExtentScrollController monthController;

  /// This widget's day selection and animation state.
  final FixedExtentScrollController dayController;

  /// The initial date and/or time of the picker.
  final DateTime initialDateTime;

  @override
  void dispose() {
    monthController.dispose();
    dayController.dispose();

    super.dispose();
  }
}
