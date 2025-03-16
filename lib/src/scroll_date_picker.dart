import 'dart:math';

import 'package:flutter/material.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:scroll_date_picker/src/widgets/date_scroll_view.dart';

import 'utils/get_monthly_date.dart';

class ScrollDatePicker extends StatefulWidget {
  ScrollDatePicker({
    Key? key,
    this.viewType,
    required this.selectedDate,
    DateTime? minimumDate,
    DateTime? maximumDate,
    required this.onDateTimeChanged,
    Locale? locale,
    DatePickerOptions? options,
    DatePickerScrollViewOptions? scrollViewOptions,
    this.indicator,
  })  : minimumDate = minimumDate ?? DateTime(1960, 1, 1),
        maximumDate = maximumDate ?? DateTime.now(),
        locale = locale ?? const Locale('en'),
        options = options ?? const DatePickerOptions(),
        scrollViewOptions =
            scrollViewOptions ?? const DatePickerScrollViewOptions(),
        super(key: key);

  /// A list that allows you to specify the type of date view.
  /// And also the order of the viewType in list is the order of the date view.
  /// If this list is null, the default order of locale is set.
  /// TODO("Satoshi"): Specify the type of date view visible.
  final List<DatePickerViewType>? viewType;

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
  final Locale locale;

  /// A set that allows you to specify options related to ScrollView.
  final DatePickerScrollViewOptions scrollViewOptions;

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

  late Widget _yearScrollView;
  late Widget _monthScrollView;
  late Widget _dayScrollView;

  late DateTime _selectedDate;
  bool isYearScrollable = true;
  bool isMonthScrollable = true;
  List<int> _years = [];
  List<int> _months = [];
  List<int> _days = [];

  int get selectedYearIndex => !_years.contains(_selectedDate.year)
      ? 0
      : _years.indexOf(_selectedDate.year);

  int get selectedMonthIndex => !_months.contains(_selectedDate.month)
      ? 0
      : _months.indexOf(_selectedDate.month);

  int get selectedDayIndex {
    return !_days.contains(_selectedDate.day)
        ? 0
        : _days.indexOf(_selectedDate.day);
  }

  int get selectedYear {
    if (_yearController.hasClients) {
      return _years[_yearController.selectedItem % _years.length];
    }
    return DateTime.now().year;
  }

  int get selectedMonth {
    if (_monthController.hasClients) {
      return _months[_monthController.selectedItem % _months.length];
    }
    return DateTime.now().month;
  }

  int get selectedDay {
    if (_dayController.hasClients) {
      return _days[_dayController.selectedItem % _days.length];
    }
    return DateTime.now().day;
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate.isAfter(widget.maximumDate) ||
            widget.selectedDate.isBefore(widget.minimumDate)
        ? DateTime.now()
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _yearController.animateToItem(selectedYearIndex,
            curve: Curves.ease, duration: const Duration(microseconds: 500));
        _monthController.animateToItem(selectedMonthIndex,
            curve: Curves.ease, duration: const Duration(microseconds: 500));
        _dayController.animateToItem(selectedDayIndex,
            curve: Curves.ease, duration: const Duration(microseconds: 500));
      });
    }
  }

  @override
  void dispose() {
    _yearController.dispose();
    _monthController.dispose();
    _dayController.dispose();
    super.dispose();
  }

  void _initDateScrollView() {
    _yearScrollView = DateScrollView(
        key: const Key("year"),
        dates: _years,
        controller: _yearController,
        options: widget.options,
        scrollViewOptions: widget.scrollViewOptions.year,
        selectedIndex: selectedYearIndex,
        locale: widget.locale,
        onTap: (int index) => _yearController.jumpToItem(index),
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
    _monthScrollView = DateScrollView(
      key: const Key("month"),
      dates: widget.locale.months.sublist(_months.first - 1, _months.last),
      controller: _monthController,
      options: widget.options,
      scrollViewOptions: widget.scrollViewOptions.month,
      selectedIndex: selectedMonthIndex,
      locale: widget.locale,
      onTap: (int index) => _monthController.jumpToItem(index),
      onChanged: (_) {
        _onDateTimeChanged();
        _initDays();
        if (isMonthScrollable) {
          _dayController.jumpToItem(selectedDayIndex);
        }
        isMonthScrollable = true;
      },
    );
    _dayScrollView = DateScrollView(
      key: const Key("day"),
      dates: _days,
      controller: _dayController,
      options: widget.options,
      scrollViewOptions: widget.scrollViewOptions.day,
      selectedIndex: selectedDayIndex,
      locale: widget.locale,
      onTap: (int index) => _dayController.jumpToItem(index),
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
    final maximumDay = getMonthlyDate(year: selectedYear, month: selectedMonth);
    _selectedDate =
        DateTime(selectedYear, selectedMonth, min(selectedDay, maximumDay));
    widget.onDateTimeChanged(_selectedDate);
  }

  List<Widget> _getScrollDatePicker() {
    _initDateScrollView();

    // set order of scroll view
    if (widget.viewType?.isNotEmpty ?? false) {
      final viewList = <Widget>[];

      for (var view in widget.viewType!) {
        switch (view) {
          case DatePickerViewType.year:
            viewList.add(_yearScrollView);
            break;
          case DatePickerViewType.month:
            viewList.add(_monthScrollView);
            break;
          case DatePickerViewType.day:
            viewList.add(_dayScrollView);
            break;
        }
      }

      return viewList;
    }

    switch (widget.locale.languageCode) {
      case zh:
      case ko:
        return [_yearScrollView, _monthScrollView, _dayScrollView];
      case vi:
      case id:
      case th:
      case de:
      case es:
      case nl:
      case fr:
      case it:
      case pt:
      case tr:
      case pl:
        return [_dayScrollView, _monthScrollView, _yearScrollView];
      default:
        return [_monthScrollView, _dayScrollView, _yearScrollView];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: widget.scrollViewOptions.mainAxisAlignment,
          crossAxisAlignment: widget.scrollViewOptions.crossAxisAlignment,
          children: _getScrollDatePicker(),
        ),
        // Date Picker Indicator
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
                        widget.options.backgroundColor,
                        widget.options.backgroundColor.withOpacity(0.7),
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
                        widget.options.backgroundColor.withOpacity(0.7),
                        widget.options.backgroundColor,
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
