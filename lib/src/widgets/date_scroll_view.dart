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
    this.isLoop = true,
  });

  final double width;

  final ValueChanged<int> onChanged;

  final int itemIndex;

  final List item;

  final FixedExtentScrollController controller;

  final String label;

  /// Date Picker configuration
  final DatePickerConfig config;

  final bool isLoop;

  List<Widget> _date = [];

  @override
  Widget build(BuildContext context) {
    _date = List<Widget>.generate(
      item.length,
      (index) => Container(
        alignment: Alignment.centerLeft,
        child: Text("${item[index]}$label", style: itemIndex == index ? config.selectedTextStyle : config.textStyle),
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
        childDelegate: isLoop
            ? ListWheelChildLoopingListDelegate(
                children: _date,
              )
            : ListWheelChildListDelegate(children: _date),
      ),
    );
  }
}
