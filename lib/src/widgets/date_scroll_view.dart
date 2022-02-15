import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scroll_date_picker/src/models/date_picker_options.dart';

class DateScrollView extends StatelessWidget {
  DateScrollView({
    this.width = 70,
    required this.onChanged,
    required this.date,
    required this.controller,
    required this.options,
    this.alignment = Alignment.center,
    this.label = "",
    this.padding = const EdgeInsets.all(0),
    required this.selectedIndex,
  });

  /// If non-null, requires the child to have exactly this Width.
  final double width;

  /// A controller for scroll views whose items have the same size.
  final FixedExtentScrollController controller;

  /// On optional listener that's called when the centered item changes.
  final ValueChanged<int> onChanged;

  /// This is a list of dates.
  final List date;

  /// A set that allows you to specify options related to ListWheelScrollView.
  final DatePickerOptions options;

  /// It's a year or month or day text sorting method.
  final Alignment alignment;

  /// Text that is printed next to the year or month or day.
  final String label;

  /// The amount of space that can be added to the year or month or day.
  final EdgeInsets padding;
  /// The currently selected date.
  final int selectedIndex;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int _maximumCount = constraints.maxHeight ~/ options.itemExtent;
        return Padding(
          padding: padding,
          child: Container(
            width: width,
            child: ListWheelScrollView.useDelegate(
              itemExtent: options.itemExtent,
              diameterRatio: options.diameterRatio,
              controller: controller,
              physics: const FixedExtentScrollPhysics(),
              perspective: options.perspective,
              onSelectedItemChanged: onChanged,
              childDelegate: options.isLoop && date.length > _maximumCount
                  ? ListWheelChildLoopingListDelegate(
                      children: List<Widget>.generate(
                        date.length,
                        (index) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: Container(
                            alignment: alignment,
                            child: Text("${date[index]}$label",
                                style: selectedIndex % date.length == index
                                    ? options.selectedTextStyle
                                    : options.textStyle),
                          ),
                        ),
                      ),
                    )
                  : ListWheelChildListDelegate(
                      children: List<Widget>.generate(
                        date.length,
                        (index) => Container(
                          alignment: alignment,
                          child: Text("${date[index]}$label",
                              style:  selectedIndex % date.length == index
                                  ? options.selectedTextStyle
                                  : options.textStyle),
                        ),
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
