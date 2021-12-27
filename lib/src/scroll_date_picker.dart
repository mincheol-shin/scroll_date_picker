import 'package:flutter/material.dart';
import 'package:scroll_date_picker/src/widgets/date_picker_indicator.dart';
import 'package:scroll_date_picker/src/widgets/date_scroll_view.dart';

import '../scroll_date_picker.dart';

class ScrollDatePicker extends StatelessWidget {
  ScrollDatePicker({
    Key? key,
    required this.controller,
    required this.onDateTimeChanged,
    this.itemExtent = 45.0,
    this.diameterRatio = 3.0,
    this.perspective = 0.01,
    this.textStyle = const TextStyle(fontSize: 18.0, color: Colors.grey),
    this.selectedTextStyle = const TextStyle(fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.w500),
    this.isLoop = true,
  }) : super(key: key);

  /// This widget's year selection and animation state.
  final DatePickerController controller;

  /// On optional listener that's called when the centered item changes.
  final ValueChanged<DateTime> onDateTimeChanged;

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

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        DateScrollView(onChanged: (value) {}, item: [1, 2, 3, 4, 5, 6, 7, 8, 9, 10], controller: controller),
        const DatePickerIndicator(),
      ],
    );
  }
}
