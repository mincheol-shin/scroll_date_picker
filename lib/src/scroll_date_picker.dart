import 'package:flutter/material.dart';
import 'package:scroll_date_picker/src/utils/get_monthly_date.dart';
import 'package:scroll_date_picker/src/widgets/date_picker_indicator.dart';
import 'package:scroll_date_picker/src/widgets/date_scroll_view.dart';

class ScrollDatePicker extends StatefulWidget {
  ScrollDatePicker({
    Key? key,
    required this.selectedDate,
    this.minimumYear = 2010,
    this.maximumYear = 2050,
    required this.onDateTimeChanged,
    this.itemExtent = 45.0,
    this.diameterRatio = 3.0,
    this.perspective = 0.01,
    this.isLoop = true,
  }) : super(key: key);

  final DateTime selectedDate;

  /// Minimum year that the picker can be scrolled
  final int minimumYear;

  /// Maximum year that the picker can be scrolled
  final int maximumYear;

  /// On optional listener that's called when the centered item changes.
  final ValueChanged<DateTime> onDateTimeChanged;

  /// Size of each child in the main axis
  final double itemExtent;

  /// {@macro flutter.rendering.wheelList.diameterRatio}
  final double diameterRatio;

  /// {@macro flutter.rendering.wheelList.perspective}
  final double perspective;

  /// The loop iterates on an explicit list of values
  final bool isLoop;

  @override
  State<ScrollDatePicker> createState() => _ScrollDatePickerState();
}

class _ScrollDatePickerState extends State<ScrollDatePicker> {
  late DateTime _selectedDate = widget.selectedDate;

  /// This widget's year selection and animation state.
  late FixedExtentScrollController _yearController = FixedExtentScrollController(initialItem: widget.selectedDate.year - widget.minimumYear);

  /// This widget's month selection and animation state.
  late FixedExtentScrollController _monthController = FixedExtentScrollController(initialItem: widget.selectedDate.month - 1);

  /// This widget's day selection and animation state.
  late FixedExtentScrollController _dayController = FixedExtentScrollController(initialItem: widget.selectedDate.day - 1);

  List<int> _years = [];
  List<int> _months = [];
  List<int> _days = [];

  @override
  void initState() {
    super.initState();
    _initYears();
    _initMonths();
    _initDays();
  }

  @override
  void didUpdateWidget(covariant ScrollDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_selectedDate != widget.selectedDate) {
      _initControllerIndex();
      _selectedDate = widget.selectedDate;
    } else if (oldWidget.minimumYear != widget.minimumYear || oldWidget.maximumYear != widget.maximumYear) {
      _initYears();
    }
  }

  void _initControllerIndex() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _yearController.jumpToItem(widget.selectedDate.year - widget.minimumYear);
      _monthController.jumpToItem(widget.selectedDate.month - 1);
      _dayController.jumpToItem(widget.selectedDate.day - 1);
    });
  }

  void _initYears() {
    _years = [for (int i = widget.minimumYear; i <= widget.maximumYear; i++) i];
  }

  void _initMonths() {
    _months = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
  }

  void _initDays() {
    int _maximumDay = getMonthlyDate(year: _selectedDate.year, month: _selectedDate.month);
    _days = [for (int i = 1; i <= _maximumDay; i++) i];
  }

  void _onDateTimeChanged() {
    int _selectedYear = _years[_yearController.selectedItem % _years.length];
    int _selectedMonth = _months[_monthController.selectedItem % _months.length];
    int _selectedDay = _days[_dayController.selectedItem % _days.length];
    int _maximumDay = getMonthlyDate(year: _selectedYear, month: _selectedMonth);
    DateTime _dateTime = DateTime(_selectedYear, _selectedMonth, _selectedDay > _maximumDay ? _maximumDay : _selectedDay);
    _selectedDate = _dateTime;
    widget.onDateTimeChanged(_dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          children: [
            DateScrollView(
                onChanged: (value) {
                  _onDateTimeChanged();
                  _initDays();
                },
                item: _years,
                controller: _yearController),
            DateScrollView(
                onChanged: (value) {
                  _onDateTimeChanged();
                  _initDays();
                },
                item: _months,
                controller: _monthController),
            DateScrollView(
                onChanged: (value) {
                  _onDateTimeChanged();
                },
                item: _days,
                controller: _dayController),
          ],
        ),
        const DatePickerIndicator(),
      ],
    );
  }
}
