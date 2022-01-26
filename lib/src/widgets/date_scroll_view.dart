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
    required this.selectedItem,
    this.padding = const EdgeInsets.all(0),
  });

  /// If non-null, requires the child to have exactly this Width.
  final double width;

  /// A controller for scroll views whose items have the same size.
  final FixedExtentScrollController controller;

  /// On optional listener that's called when the centered item changes.
  final ValueChanged<int> onChanged;

  /// This is a list of dates.
  final List date;

  final DatePickerOptions options;

  final Alignment alignment;

  final String label;

  final String selectedItem;

  final EdgeInsets padding;

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
                            child: Text("${date[index]}$label", style: "${date[index]}" == selectedItem ? options.selectedTextStyle : options.textStyle),
                          ),
                        ),
                      ),
                    )
                  : ListWheelChildListDelegate(
                      children: List<Widget>.generate(
                        date.length,
                        (index) => Container(
                          alignment: alignment,
                          child: Text("${date[index]}$label", style: "${date[index]}" == selectedItem ? options.selectedTextStyle : options.textStyle),
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
