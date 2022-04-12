import 'package:clickable_list_wheel_view/clickable_list_wheel_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class DateScrollView extends StatelessWidget {
  DateScrollView({
    this.width = 70,
    required this.height,
    required this.onChanged,
    required this.date,
    required this.controller,
    required this.options,
    required this.style,
    this.alignment = Alignment.center,
    this.label = "",
    this.padding = const EdgeInsets.all(0),
    required this.selectedIndex,
    required this.scrollOnTap,
  });

  /// If non-null, requires the child to have exactly this Width.
  final double width;

  ///for enalbing onTap touch
  final double height;

  /// A controller for scroll views whose items have the same size.
  final FixedExtentScrollController controller;

  /// On optional listener that's called when the centered item changes.
  final ValueChanged<int> onChanged;

  /// This is a list of dates.
  final List date;

  /// A set that allows you to specify options related to ListWheelScrollView.
  final DatePickerOptions options;

  final DatePickerStyle style;

  /// It's a year or month or day text sorting method.
  final Alignment alignment;

  /// Text that is printed next to the year or month or day.
  final String label;

  /// The amount of space that can be added to the year or month or day.
  final EdgeInsets padding;

  /// The currently selected date index.
  final int selectedIndex;

  /// Whether to scroll to tapped item.
  final bool scrollOnTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int _maximumCount = constraints.maxHeight ~/ options.itemExtent;
        final ListWheelScrollView _scrollView = ListWheelScrollView.useDelegate(
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
                    (index) => _buildDateView(index: index),
                  ),
                )
              : ListWheelChildListDelegate(
                  children: List<Widget>.generate(
                    date.length,
                    (index) => _buildDateView(index: index),
                  ),
                ),
        );
        return Padding(
          padding: padding,
          child: Container(
            width: width,
            child: (scrollOnTap &&
                    !options
                        .isLoop) // TODO(yangsoo12): Handle scrolling for looped scroll view
                ? ClickableListWheelScrollView(
                    scrollController: controller,
                    itemHeight: height,
                    itemCount: date.length,
                    onItemTapCallback: (index) {
                      print("onItemTapCallback index: $index");
                    },
                    child: _scrollView,
                  )
                : _scrollView,
          ),
        );
      },
    );
  }

  Widget _buildDateView({required int index}) {
    return Container(
      alignment: alignment,
      child: Text(
        "${date[index]}$label",
        style:
            selectedIndex == index ? style.selectedTextStyle : style.textStyle,
      ),
    );
  }
}
