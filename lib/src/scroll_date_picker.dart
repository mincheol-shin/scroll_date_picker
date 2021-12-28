import 'package:flutter/material.dart';
import 'package:scroll_date_picker/src/models/date_picker_options.dart';
import 'package:scroll_date_picker/src/utils/get_monthly_date.dart';
import 'package:scroll_date_picker/src/widgets/date_picker_indicator.dart';
import 'package:scroll_date_picker/src/widgets/date_scroll_view.dart';

import 'scroll_date_picker_constants.dart';

class ScrollDatePicker extends StatefulWidget {
  ScrollDatePicker({
    Key? key,
    required this.selectedDate,
    required this.onDateTimeChanged,
    this.minimumYear = 2010,
    this.maximumYear = 2050,
    this.options = const DatePickerOptions(),
    this.locale = DatePickerLocale.en_us,
  }) : super(key: key);

  final DateTime selectedDate;

  /// Minimum year that the picker can be scrolled
  final int minimumYear;

  /// Maximum year that the picker can be scrolled
  final int maximumYear;

  /// On optional listener that's called when the centered item changes.
  final ValueChanged<DateTime> onDateTimeChanged;

  final DatePickerOptions options;

  /// Set calendar language
  final DatePickerLocale locale;

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
  late Widget _yearWidget;
  late Widget _monthWidget;
  late Widget _dayWidget;
  List<int> _years = [];
  List<int> _days = [];

  @override
  void initState() {
    super.initState();
    _initYears();
    _initDays();
  }

  @override
  void didUpdateWidget(covariant ScrollDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_selectedDate != widget.selectedDate) {
      _initControllerIndex();
    } else if (oldWidget.minimumYear != widget.minimumYear || oldWidget.maximumYear != widget.maximumYear) {
      _initYears();
    }
  }

  @override
  void dispose() {
    _yearController.dispose();
    _monthController.dispose();
    _dayController.dispose();
    super.dispose();
  }

  void _initDatePickerWidgets() {
    _yearWidget = DateScrollView(
      width: widget.locale.localeOptions.yearWidth,
      date: _years,
      controller: _yearController,
      options: widget.options,
      label: widget.locale.localeOptions.yearLabel,
      alignment: widget.locale.localeOptions.yearAlignment,
      onChanged: (value) {
        _onDateTimeChanged();
        _initDays();
      },
    );
    _monthWidget = DateScrollView(
      width: widget.locale.localeOptions.monthWidth,
      date: widget.locale.month,
      controller: _monthController,
      options: widget.options,
      label: widget.locale.localeOptions.monthLabel,
      alignment: widget.locale.localeOptions.monthAlignment,
      onChanged: (value) {
        _onDateTimeChanged();
        _initDays();
      },
    );
    _dayWidget = DateScrollView(
      width: widget.locale.localeOptions.dayWidth,
      date: _days,
      controller: _dayController,
      options: widget.options,
      label: widget.locale.localeOptions.dayLabel,
      alignment: widget.locale.localeOptions.dayAlignment,
      onChanged: (value) {
        _onDateTimeChanged();
      },
    );
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

  void _initDays() {
    int _maximumDay = getMonthlyDate(year: _selectedDate.year, month: _selectedDate.month);
    _days = [for (int i = 1; i <= _maximumDay; i++) i];
    _dayController.jumpToItem(_days.indexOf(_selectedDate.day));
  }

  void _onDateTimeChanged() {
    int _selectedYear = _years[_yearController.selectedItem % _years.length];
    int _selectedMonth = (_monthController.selectedItem % 12) + 1;
    int _selectedDay = _days[_dayController.selectedItem % _days.length];
    int _maximumDay = getMonthlyDate(year: _selectedYear, month: _selectedMonth);
    DateTime _dateTime = DateTime(_selectedYear, _selectedMonth, _selectedDay > _maximumDay ? _maximumDay : _selectedDay);
    _selectedDate = _dateTime;

    widget.onDateTimeChanged(_dateTime);
  }

  List<Widget> _buildDatePickerWidgets() {
    _initDatePickerWidgets();
    switch (widget.locale) {
      case DatePickerLocale.ko_kr:
        return [_yearWidget, _monthWidget, _dayWidget];
      default:
        return [_monthWidget, _dayWidget, _yearWidget];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildDatePickerWidgets(),
        ),
        const DatePickerIndicator(),
      ],
    );
  }
}
