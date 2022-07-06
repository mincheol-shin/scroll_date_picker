import 'package:flutter/material.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:scroll_date_picker/src/widgets/date_scroll_view.dart';

import 'utils/get_monthly_date.dart';

class ScrollDatePicker extends StatefulWidget {
  ScrollDatePicker({
    Key? key,
    required DateTime selectedDate,
    DateTime? minimumDate,
    DateTime? maximumDate,
    required ValueChanged<DateTime> onDateTimeChanged,
    DatePickerLocale? locale,
    DatePickerOptions? options,
    DatePickerLocaleOptions? localeOptions,
    DatePickerStyle? style,
    Widget? indicator,
  })  : selectedDate = selectedDate,
        minimumDate = minimumDate ?? DateTime(1960, 1, 1),
        maximumDate = maximumDate ?? DateTime.now(),
        onDateTimeChanged = onDateTimeChanged,
        locale = locale ?? DatePickerLocale.enUS,
        options = options ?? const DatePickerOptions(),
        localeOptions = localeOptions,
        style = style ?? const DatePickerStyle(),
        indicator = indicator;

  /// The currently selected date.
  final DateTime selectedDate;

  /// Minimum year that the picker can be scrolled
  final DateTime minimumDate;

  /// Maximum year that the picker can be scrolled
  final DateTime maximumDate;

  /// On optional listener that's called when the centered item changes.
  final ValueChanged<DateTime> onDateTimeChanged;

  /// A set that allows you to specify options related to ListWheelScrollView.
  final DatePickerOptions options;

  /// Set calendar language
  final DatePickerLocale locale;

  /// Options that can be applied nationally or collectively.
  final DatePickerLocaleOptions? localeOptions;

  final DatePickerStyle style;

  /// Indicator displayed in the center of the ScrollDatePicker
  final Widget? indicator;

  @override
  State<ScrollDatePicker> createState() => _ScrollDatePickerState();
}

class _ScrollDatePickerState extends State<ScrollDatePicker> {
  /// This widget's year selection and animation state.
  late FixedExtentScrollController _yearController;

  /// This widget's month selection and animation state.
  late FixedExtentScrollController _monthController;

  /// This widget's day selection and animation state.
  late FixedExtentScrollController _dayController;
  late DatePickerLocaleOptions _localeOptions =
      widget.localeOptions ?? widget.locale.localeOptions;

  late Widget _yearWidget;
  late Widget _monthWidget;
  late Widget _dayWidget;
  final DateTime _now = DateTime.now();

  late DateTime _selectedDate;
  bool isYearScrollable = true;
  bool isMonthScrollable = true;
  List<int> _years = [];
  List<int> _months = [];
  List<int> _days = [];

  int get selectedYearIndex => _years.indexOf(_selectedDate.year) == -1
      ? 0
      : _years.indexOf(_selectedDate.year);

  int get selectedMonthIndex => _months.indexOf(_selectedDate.month) == -1
      ? 0
      : _months.indexOf(_selectedDate.month);

  int get selectedDayIndex => _days.indexOf(_selectedDate.day) == -1
      ? 0
      : _days.indexOf(_selectedDate.day);

  int get selectedYear => _years[_yearController.selectedItem % _years.length];

  int get selectedMonth =>
      _months[_monthController.selectedItem % _months.length];

  int get selectedDay => _days[_dayController.selectedItem % _days.length];

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate.isAfter(widget.maximumDate) ||
            widget.selectedDate.isBefore(widget.minimumDate)
        ? _now
        : widget.selectedDate;

    _years = [
      for (int i = widget.minimumDate.year; i <= widget.maximumDate.year; i++) i
    ];
    _initMonths();
    _initDays();
    _yearController =
        FixedExtentScrollController(initialItem: selectedYearIndex);
    _monthController =
        FixedExtentScrollController(initialItem: selectedMonthIndex);
    _dayController = FixedExtentScrollController(initialItem: selectedDayIndex);
  }

  @override
  void didUpdateWidget(covariant ScrollDatePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_selectedDate != widget.selectedDate) {
      _selectedDate = widget.selectedDate;
      isYearScrollable = false;
      isMonthScrollable = false;
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        _yearController.animateToItem(selectedYearIndex,
            curve: Curves.ease, duration: Duration(microseconds: 500));
        _monthController.animateToItem(selectedMonthIndex,
            curve: Curves.ease, duration: Duration(microseconds: 500));
        _dayController.animateToItem(selectedDayIndex,
            curve: Curves.ease, duration: Duration(microseconds: 500));
      });
    }
  }

  void dispose() {
    _yearController.dispose();
    _monthController.dispose();
    _dayController.dispose();
    super.dispose();
  }

  void _initDatePickerWidgets() {
    _yearWidget = DateScrollView(
        date: _years,
        controller: _yearController,
        options: widget.options,
        width: _localeOptions.yearWidth,
        label: _localeOptions.yearLabel,
        alignment: _localeOptions.yearAlignment,
        padding: _localeOptions.yearPadding,
        style: widget.style,
        selectedIndex: selectedYearIndex,
        onChanged: (_) {
          _onDateTimeChanged();
          _initMonths();
          _initDays();
          if (isYearScrollable) {
            _monthController.jumpToItem(selectedMonthIndex);
            _dayController.jumpToItem(selectedDayIndex);
          }
          isYearScrollable = true;
        });
    _monthWidget = DateScrollView(
      date: widget.locale.pickerMonthsInGivenYear(_months),
      controller: _monthController,
      options: widget.options,
      width: _localeOptions.monthWidth,
      label: _localeOptions.monthLabel,
      alignment: _localeOptions.monthAlignment,
      padding: _localeOptions.monthPadding,
      style: widget.style,
      selectedIndex: selectedMonthIndex,
      onChanged: (_) {
        _onDateTimeChanged();
        _initDays();
        if (isMonthScrollable) {
          _dayController.jumpToItem(selectedDayIndex);
        }
        isMonthScrollable = true;
      },
    );
    _dayWidget = DateScrollView(
      width: _localeOptions.dayWidth,
      date: _days,
      controller: _dayController,
      options: widget.options,
      label: _localeOptions.dayLabel,
      alignment: _localeOptions.dayAlignment,
      padding: _localeOptions.dayPadding,
      style: widget.style,
      selectedIndex: selectedDayIndex,
      onChanged: (_) {
        _onDateTimeChanged();
        _initDays();
      },
    );
  }

  void _initMonths() {
    if (_selectedDate.year == widget.maximumDate.year &&
        _selectedDate.year == widget.minimumDate.year) {
      _months = [
        for (int i = widget.minimumDate.month;
            i <= widget.maximumDate.month;
            i++)
          i
      ];
    } else if (_selectedDate.year == widget.maximumDate.year) {
      _months = [for (int i = 1; i <= widget.maximumDate.month; i++) i];
    } else if (_selectedDate.year == widget.minimumDate.year) {
      _months = [for (int i = widget.minimumDate.month; i <= 12; i++) i];
    } else {
      _months = [for (int i = 1; i <= 12; i++) i];
    }
  }

  void _initDays() {
    int _maximumDay =
        getMonthlyDate(year: _selectedDate.year, month: _selectedDate.month);
    _days = [for (int i = 1; i <= _maximumDay; i++) i];
    if (_selectedDate.year == widget.maximumDate.year &&
        _selectedDate.month == widget.maximumDate.month &&
        _selectedDate.year == widget.minimumDate.year &&
        _selectedDate.month == widget.minimumDate.month) {
      _days = _days.sublist(widget.minimumDate.day - 1, widget.maximumDate.day);
    } else if (_selectedDate.year == widget.maximumDate.year &&
        _selectedDate.month == widget.maximumDate.month) {
      _days = _days.sublist(0, widget.maximumDate.day);
    } else if (_selectedDate.year == widget.minimumDate.year &&
        _selectedDate.month == widget.minimumDate.month) {
      _days = _days.sublist(widget.minimumDate.day - 1, _days.length);
    }
  }

  void _onDateTimeChanged() {
    _selectedDate = DateTime(selectedYear, selectedMonth, selectedDay);
    widget.onDateTimeChanged(_selectedDate);
  }

  List<Widget> _buildDatePickerWidgets() {
    _initDatePickerWidgets();
    switch (widget.locale) {
      case DatePickerLocale.koKR:
        return [_yearWidget, _monthWidget, _dayWidget];
      case DatePickerLocale.viVN:
        return [_dayWidget, _monthWidget, _yearWidget];
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
              widget.indicator ??
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
