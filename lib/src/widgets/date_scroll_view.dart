import 'package:flutter/cupertino.dart';
import 'package:scroll_date_picker/src/models/date_picker_options.dart';

class DateScrollView extends StatelessWidget {
  DateScrollView({
    required this.onChanged,
    required this.date,
    required this.controller,
    required this.options,
    this.label = "",
  });

  /// A controller for scroll views whose items have the same size.
  final FixedExtentScrollController controller;

  /// On optional listener that's called when the centered item changes.
  final ValueChanged<int> onChanged;

  /// This is a list of dates.
  final List date;

  final DatePickerOptions options;

  final String label;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ListWheelScrollView.useDelegate(
        itemExtent: options.itemExtent,
        diameterRatio: options.diameterRatio,
        controller: controller,
        physics: const FixedExtentScrollPhysics(),
        perspective: options.perspective,
        onSelectedItemChanged: onChanged,
        childDelegate: options.isLoop
            ? ListWheelChildLoopingListDelegate(
                children: List<Widget>.generate(
                  date.length,
                  (index) => Container(
                    alignment: Alignment.center,
                    child: Text("${date[index]}$label", style: CupertinoTheme.of(context).textTheme.dateTimePickerTextStyle),
                  ),
                ),
              )
            : ListWheelChildListDelegate(
                children: List<Widget>.generate(
                  date.length,
                  (index) => Container(
                    alignment: Alignment.center,
                    child: Text("${date[index]}$label", style: CupertinoTheme.of(context).textTheme.dateTimePickerTextStyle),
                  ),
                ),
              ),
      ),
    );
  }
}
