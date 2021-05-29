import 'package:flutter/material.dart';

import '../utils/date_picker_config.dart';

class DateScrollView extends StatelessWidget {
  DateScrollView({
    this.width = 45.0,
    required this.onChanged,
    this.itemIndex = 0,
    required this.item,
    required this.controller,
    this.label = "",
    required this.config,
  });

  /// If non-null, requires the child to have exactly this Width.
  final double width;

  /// On optional listener that's called when the centered item changes.
  final ValueChanged<int> onChanged;

  /// The index of the currently selected date.
  final int itemIndex;

  /// This is a list of dates.
  final List item;

  /// A controller for scroll views whose items have the same size.
  final FixedExtentScrollController controller;

  final String label;

  /// Date Picker configuration
  final DatePickerConfig config;

  List<Widget> _date = [];

  @override
  Widget build(BuildContext context) {
    _date = List<Widget>.generate(
      item.length,
      (index) => Container(
        alignment: Alignment.centerLeft,
        child: Text("${item[index]}$label",
            style: itemIndex == index
                ? config.selectedTextStyle
                : config.textStyle),
      ),
    );

    return Container(
      width: width,
      child: ListWheelScrollView.useDelegate(
        itemExtent: config.itemExtent,
        diameterRatio: config.diameterRatio,
        controller: controller,
        physics: FixedExtentScrollPhysics(),
        perspective: config.perspective,
        onSelectedItemChanged: onChanged,
        childDelegate: config.isLoop
            ? ListWheelChildLoopingListDelegate(
                children: _date,
              )
            : ListWheelChildListDelegate(
                children: _date,
              ),
      ),
    );
  }
}
