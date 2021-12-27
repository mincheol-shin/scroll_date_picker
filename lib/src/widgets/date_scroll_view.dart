import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DateScrollView extends StatelessWidget {
  DateScrollView({
    this.width = 45.0,
    required this.onChanged,
    this.itemIndex = 0,
    required this.item,
    required this.controller,
    this.label = "",
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


  List<Widget> _date = [];

  @override
  Widget build(BuildContext context) {
    _date = List<Widget>.generate(
      item.length,
      (index) => Container(
        alignment: Alignment.center,
        child: Text("${item[index]}$label", style: CupertinoTheme.of(context).textTheme.dateTimePickerTextStyle),
      ),
    );

    return Container(
      alignment: Alignment.center,
      child: ListWheelScrollView.useDelegate(
        itemExtent: 35,
        diameterRatio: 3,
        controller: controller,
        physics: FixedExtentScrollPhysics(),
        perspective: 0.01,
        onSelectedItemChanged: onChanged,
        childDelegate:true
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
