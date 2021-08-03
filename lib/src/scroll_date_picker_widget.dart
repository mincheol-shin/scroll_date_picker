import 'package:flutter/material.dart';
import 'package:scroll_date_picker/src/widgets/date_scroll_view.dart';

import 'components/date_picker_config.dart';
import 'components/date_picker_controller.dart';
import 'utils/get_monthly_date.dart';

class ScrollDatePicker extends StatefulWidget {
  ScrollDatePicker({
    Key? key,
    required this.controller,
    this.height = 300.0,
    required this.onChanged,
    this.pickerDecoration = const BoxDecoration(color: Colors.black12),
    this.locale = DatePickerLocale.ko_kr,
    this.config,
  }) : super(key: key);

  /// This widget's year selection and animation state.
  final DatePickerController controller;

  /// If non-null, requires the child to have exactly this height.
  final double height;

  /// On optional listener that's called when the centered item changes.
  final ValueChanged<DateTime> onChanged;

  /// An immutable description of how to paint a box.
  final BoxDecoration pickerDecoration;

  /// Set calendar language
  final DatePickerLocale locale;

  /// Date Picker configuration
  final DatePickerConfig? config;

  @override
  _ScrollDatePickerState createState() => _ScrollDatePickerState();
}

class _ScrollDatePickerState extends State<ScrollDatePicker> {
  late DatePickerConfig _config;
  List _month = [];
  List<int> _day = [];
  List<int> _year = [];

  int _selectedYear = 0;
  var _selectedMonth;
  int _selectedDay = 0;

  late int _monthIndex;
  late int _dayIndex;
  late int _yearIndex;

  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _config = widget.config ?? DatePickerConfig();

    _year = [
      for (int i = widget.controller.minYear;
          i <= widget.controller.maxYear;
          i++)
        i
    ];
    _month = widget.locale.month;

    _selectedYear = widget.controller.initialDateTime.year;
    _selectedMonth = widget.controller.initialDateTime.month;
    _selectedDay = widget.controller.initialDateTime.day;

    _day = [
      for (int i = 1;
          i <= getMonthlyDate(month: _selectedMonth, year: _selectedYear);
          i++)
        i
    ];

    _yearIndex =
        widget.controller.initialDateTime.year - widget.controller.minYear;
    _selectedYear = _year[_yearIndex];

    _monthIndex = widget.controller.monthController.initialItem;
    _selectedMonth = _month[_monthIndex];

    _dayIndex = widget.controller.dayController.initialItem;
    _selectedDay = _day[_dayIndex];
  }

  void _scrollToSelectedDay() {
    int selectedDayIndex = _day.indexOf(_selectedDay);
    if (selectedDayIndex != -1) {
      widget.controller.dayController.jumpTo(0.1);
      widget.controller.dayController
          .jumpTo(selectedDayIndex * _config.itemExtent);
    } else {
      widget.controller.dayController.jumpTo(0.1);
      widget.controller.dayController.jumpTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollUpdateNotification) {
          DateTime date = DateTime.parse(
              "$_selectedYear-${dateFormatter(_monthIndex + 1)}-${dateFormatter(_selectedDay)}");
          if (date != _selectedDate) {
            setState(() {
              _selectedDate = date;
            });
            widget.onChanged(DateTime.parse(
                "$_selectedYear-${dateFormatter(_monthIndex + 1)}-${dateFormatter(_selectedDay)}"));
          }
        }
        return false;
      },
      child: SizedBox(
        height: widget.height,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Container(
                height: _config.itemExtent,
                decoration: widget.pickerDecoration,
              ),
            ),
            widget.locale == DatePickerLocale.ko_kr
                ? _koKRDatePicker()
                : _enUSDatePicker()
          ],
        ),
      ),
    );
  }

  Widget _enUSDatePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DateScrollView(
            width: 120.0,
            controller: widget.controller.monthController,
            itemIndex: _monthIndex,
            item: _month,
            config: _config,
            onChanged: (value) {
              setState(() {
                _monthIndex = value;
                _selectedMonth = _month[value];
                _day = [
                  for (int i = 1;
                      i <=
                          getMonthlyDate(
                              month: _monthIndex + 1, year: _selectedYear);
                      i++)
                    i
                ];
              });
              _scrollToSelectedDay();
            }),
        SizedBox(
          width: 16.0,
        ),
        DateScrollView(
            controller: widget.controller.dayController,
            itemIndex: _dayIndex,
            item: _day,
            config: _config,
            onChanged: (value) {
              setState(() {
                _dayIndex = value;
                _selectedDay = _day[value];
              });
            }),
        SizedBox(
          width: 16.0,
        ),
        DateScrollView(
            width: 70.0,
            controller: widget.controller,
            itemIndex: _yearIndex,
            item: _year,
            config: _config,
            onChanged: (value) {
              setState(() {
                _yearIndex = value;
                _selectedYear = _year[value];
                _day = [
                  for (int i = 1;
                      i <=
                          getMonthlyDate(
                              month: _monthIndex + 1, year: _selectedYear);
                      i++)
                    i
                ];
              });
              _scrollToSelectedDay();
            }),
      ],
    );
  }

  Widget _koKRDatePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DateScrollView(
          width: 70.0,
          controller: widget.controller,
          itemIndex: _yearIndex,
          item: _year,
          config: _config,
          label: "년",
          onChanged: (value) {
            setState(() {
              _yearIndex = value;
              _selectedYear = _year[value];
              _day = [
                for (int i = 1;
                    i <=
                        getMonthlyDate(
                            month: _monthIndex + 1, year: _selectedYear);
                    i++)
                  i
              ];
            });
            _scrollToSelectedDay();
          },
        ),
        SizedBox(
          width: 16.0,
        ),
        DateScrollView(
            width: 45.0,
            controller: widget.controller.monthController,
            itemIndex: _monthIndex,
            item: _month,
            config: _config,
            label: "월",
            onChanged: (value) {
              setState(() {
                _monthIndex = value;
                _selectedMonth = _month[value];
                _day = [
                  for (int i = 1;
                      i <=
                          getMonthlyDate(
                              month: _monthIndex + 1, year: _selectedYear);
                      i++)
                    i
                ];
              });
              _scrollToSelectedDay();
            }),
        SizedBox(
          width: 16.0,
        ),
        DateScrollView(
          width: 45.0,
          controller: widget.controller.dayController,
          itemIndex: _dayIndex,
          item: _day,
          config: _config,
          label: "일",
          onChanged: (value) {
            setState(() {
              _dayIndex = value;
              _selectedDay = _day[value];
            });
          },
        ),
      ],
    );
  }
}
