import 'package:flutter/material.dart';
import 'package:scroll_date_picker/src/models/date_picker_locale_options.dart';
import 'package:scroll_date_picker/src/models/date_picker_options.dart';
import 'package:scroll_date_picker/src/utils/get_monthly_date.dart';
import 'package:scroll_date_picker/src/widgets/date_scroll_view.dart';

import 'scroll_date_picker_constants.dart';

class ScrollDatePicker extends StatefulWidget {
  ScrollDatePicker({
    Key? key,
    required this.selectedDate,
    required this.onDateTimeChanged,
    this.minimumDate,
    this.maximumDate,
    this.options = const DatePickerOptions(),
    this.locale = DatePickerLocale.enUS,
    this.localeOptions,
  }) : super(key: key);

  /// The currently selected date.
  final DateTime selectedDate;

  /// Minimum year that the picker can be scrolled
  final DateTime? minimumDate;

  /// Maximum year that the picker can be scrolled
  final DateTime? maximumDate;

  /// On optional listener that's called when the centered item changes.
  final ValueChanged<DateTime> onDateTimeChanged;

  /// A set that allows you to specify options related to ListWheelScrollView.
  final DatePickerOptions options;

  /// Set calendar language
  final DatePickerLocale locale;

  /// Options that can be applied nationally or collectively.
  final DatePickerLocaleOptions? localeOptions;

  @override
  State<ScrollDatePicker> createState() => _ScrollDatePickerState();
}

class _ScrollDatePickerState extends State<ScrollDatePicker> {
  late DateTime _selectedDate = widget.selectedDate;

  /// This widget's year selection and animation state.
  late FixedExtentScrollController _yearController;

  /// This widget's month selection and animation state.
  late FixedExtentScrollController _monthController;

  /// This widget's day selection and animation state.
  late FixedExtentScrollController _dayController;
  late Widget _yearWidget;
  late Widget _monthWidget;
  late Widget _dayWidget;

  late DateTime _minimumDate;
  late DateTime _maximumDate;

  late DatePickerLocaleOptions _datePickerLocaleOptions;

  List<int> _years = [];
  List<String> _months = [];
  List<int> _days = [];

  @override
  void initState() {
    super.initState();
    _initMinimumDate();
    _initMaximumDate();
    _yearController = FixedExtentScrollController(
        initialItem: widget.selectedDate.year - _minimumDate.year);
    _monthController =
        FixedExtentScrollController(initialItem: widget.selectedDate.month - 1);
    _dayController =
        FixedExtentScrollController(initialItem: widget.selectedDate.day - 1);
    _initYears();
    _initMonths();
    _initDays();

    _datePickerLocaleOptions =
        widget.localeOptions ?? widget.locale.localeOptions;
  }

  @override
  void didUpdateWidget(covariant ScrollDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_selectedDate != widget.selectedDate) {
      _initControllerIndex();
    } else if ((widget.minimumDate != null &&
            widget.minimumDate != _minimumDate) ||
        (widget.maximumDate != null && widget.maximumDate != _maximumDate)) {
      _initMinimumDate();
      _initMaximumDate();
      _initYears();
      _initMonths();
      _initDays();
    }
  }

  @override
  void dispose() {
    _yearController.dispose();
    _monthController.dispose();
    _dayController.dispose();
    super.dispose();
  }

  void _initMinimumDate() {
    _minimumDate = widget.minimumDate ?? DateTime(1960, 12, 31);
  }

  void _initMaximumDate() {
    _maximumDate = widget.maximumDate ?? DateTime.now();
  }

  void _initDatePickerWidgets() {
    _yearWidget = DateScrollView(
      width: _datePickerLocaleOptions.yearWidth,
      date: _years,
      controller: _yearController,
      selectedItem: "${widget.selectedDate.year}",
      options: widget.options,
      label: _datePickerLocaleOptions.yearLabel,
      alignment: _datePickerLocaleOptions.yearAlignment,
      padding: _datePickerLocaleOptions.yearPadding,
      onChanged: (value) {
        _onDateTimeChanged();
        _initMonths();
        _initDays();
      },
    );
    _monthWidget = DateScrollView(
      width: _datePickerLocaleOptions.monthWidth,
      date: _months,
      controller: _monthController,
      options: widget.options,
      label: _datePickerLocaleOptions.monthLabel,
      selectedItem: "$selectedMonthToString",
      alignment: _datePickerLocaleOptions.monthAlignment,
      padding: _datePickerLocaleOptions.monthPadding,
      onChanged: (value) {
        _onDateTimeChanged();
        _initDays();
      },
    );
    _dayWidget = DateScrollView(
      width: _datePickerLocaleOptions.dayWidth,
      date: _days,
      controller: _dayController,
      options: widget.options,
      label: _datePickerLocaleOptions.dayLabel,
      selectedItem: "${widget.selectedDate.day}",
      alignment: _datePickerLocaleOptions.dayAlignment,
      padding: _datePickerLocaleOptions.dayPadding,
      onChanged: (value) {
        _onDateTimeChanged();
      },
    );
  }

  void _initControllerIndex() {
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _yearController.jumpToItem(widget.selectedDate.year - _minimumDate.year);
      _monthController.jumpToItem(widget.selectedDate.month - 1);
      _dayController.jumpToItem(widget.selectedDate.day - 1);
    });
  }

  void _initYears() {
    _years = [for (int i = _minimumDate.year; i <= _maximumDate.year; i++) i];
  }

  void _initMonths() {
    if (_selectedDate.year == _maximumDate.year ||
        _selectedDate.year == _minimumDate.year) {
      if (_selectedDate.year == _maximumDate.year) {
        _months = widget.locale.month.sublist(0, _maximumDate.month);
      } else {
        _months = widget.locale.month.sublist(0, _minimumDate.month);
      }
    } else {
      _months = widget.locale.month;
    }
    int _selectedMonthIndex = _months.indexOf(selectedMonthToString);
    _monthController.jumpToItem(
        _selectedMonthIndex == -1 ? _months.length - 1 : _selectedMonthIndex);
  }

  void _initDays() {
    int _maximumDay =
        getMonthlyDate(year: _selectedDate.year, month: _selectedDate.month);

    _days = [for (int i = 1; i <= _maximumDay; i++) i];
    if (_selectedDate.year == _maximumDate.year &&
        _selectedDate.month == _maximumDate.month) {
      _days = _days.sublist(0, _maximumDate.day);
    } else if (_selectedDate.year == _minimumDate.year &&
        _selectedDate.month == _minimumDate.month) {
      _days = _days.sublist(0, _minimumDate.day);
    }

    int _selectedDayIndex = _days.indexOf(_selectedDate.day);
    _dayController.jumpToItem(
        _selectedDayIndex == -1 ? _days.length - 1 : _selectedDayIndex);
  }

  void _onDateTimeChanged() {
    int _selectedYear = _years[_yearController.selectedItem % _years.length];
    int _selectedMonth = (_monthController.selectedItem % _months.length) + 1;
    int _selectedDay = _days[_dayController.selectedItem % _days.length];
    int _maximumDay =
        getMonthlyDate(year: _selectedYear, month: _selectedMonth);
    DateTime _dateTime = DateTime(_selectedYear, _selectedMonth,
        _selectedDay > _maximumDay ? _maximumDay : _selectedDay);
    _selectedDate = _dateTime;
    widget.onDateTimeChanged(_dateTime);
  }

  List<Widget> _buildDatePickerWidgets() {
    _initDatePickerWidgets();
    switch (widget.locale) {
      case DatePickerLocale.koKR:
        return [_yearWidget, _monthWidget, _dayWidget];
      default:
        return [_monthWidget, _dayWidget, _yearWidget];
    }
  }

  String get selectedMonthToString =>
      _months[(_selectedDate.month) > _months.length
          ? _months.length - 1
          : _selectedDate.month - 1];

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _buildDatePickerWidgets(),
        ),

        /// Date Picker Indicator
        IgnorePointer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context).scaffoldBackgroundColor,
                        Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.7),
                      ],
                    ),
                  ),
                ),
              ),
              widget.options.indicator ??
                  Container(
                    height: widget.options.itemExtent,
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.15),
                      borderRadius: const BorderRadius.all(Radius.circular(4)),
                    ),
                  ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Theme.of(context)
                            .scaffoldBackgroundColor
                            .withOpacity(0.7),
                        Theme.of(context).scaffoldBackgroundColor,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
