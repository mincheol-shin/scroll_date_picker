import 'package:flutter/material.dart';
import 'package:scroll_date_picker/src/widgets/date_scroll_view.dart';

import 'utils/date_picker_config.dart';
import 'utils/date_formatter.dart';
import 'utils/get_monthly_date.dart';



class ScrollDatePicker extends StatefulWidget {
  ScrollDatePicker({
    Key? key,
    this.yearController,
    this.dayController,
    this.monthController,
    this.height = 300.0,
    this.minYear = 2000,
    this.maxYear = 2100,
    required this.initDateTime,
    required this.onChanged,
    this.selectedBoxDecoration = const BoxDecoration(color: Colors.black12),
    this.isLoop = true,
    this.locale = DatePickerLocale.ko_kr,
    this.config,
  }) : super(key: key);

  /// This widget's year selection and animation state.
  final FixedExtentScrollController? yearController;

  /// This widget's month selection and animation state.
  final FixedExtentScrollController? monthController;

  /// This widget's day selection and animation state.
  final FixedExtentScrollController? dayController;

  /// If non-null, requires the child to have exactly this height.
  final double height;

  /// Minimum year that the picker can be scrolled
  final int minYear;

  /// Maximum year that the picker can be scrolled
  final int maxYear;

  /// The initial date and/or time of the picker.
  final DateTime initDateTime;

  /// On optional listener that's called when the centered item changes.
  final ValueChanged<DateTime> onChanged;

  /// An immutable description of how to paint a box.
  final BoxDecoration selectedBoxDecoration;

  /// The loop iterates on an explicit list of values
  final bool isLoop;

  /// Set calendar language
  final DatePickerLocale locale;

  /// Date Picker configuration
  final DatePickerConfig? config;

  @override
  _ScrollDatePickerState createState() => _ScrollDatePickerState();
}

class _ScrollDatePickerState extends State<ScrollDatePicker> {
  late FixedExtentScrollController _yearController;
  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _dayController;

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
    _year = [for (int i = widget.minYear; i <= widget.maxYear; i++) i];

    if (widget.locale == DatePickerLocale.ko_kr) {
      _month = [for (int i = 1; i <= 12; i++) i];
    } else {
      _month = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
    }

    _selectedYear = widget.initDateTime.year;
    _selectedMonth = widget.initDateTime.month;
    _selectedDay = widget.initDateTime.day;


    _day = [for (int i = 1; i <= getMonthlyDate(month: _selectedMonth, year: _selectedYear); i++) i];

    if (widget.yearController == null) {
      _yearIndex = _year.indexOf(_selectedYear);
    } else {
      _yearIndex = widget.yearController!.initialItem;
      _selectedYear = _year[_yearIndex];
    }

    if (widget.monthController == null) {
      _monthIndex = _month.indexOf(_selectedMonth);
    } else {
      _monthIndex = widget.monthController!.initialItem;
      _selectedMonth = _month[_monthIndex];
    }

    if (widget.dayController == null) {
      _dayIndex = _day.indexOf(_selectedDay);
    } else {
      _dayIndex = widget.dayController!.initialItem;
      _selectedDay = _day[_dayIndex];
    }

    _yearController = widget.yearController ?? FixedExtentScrollController(initialItem: _yearIndex);
    _monthController = widget.monthController ?? FixedExtentScrollController(initialItem: _monthIndex);
    _dayController = widget.dayController ?? FixedExtentScrollController(initialItem: _dayIndex);
  }

  void _updateDay() {
    int selectedDayIndex = _day.indexOf(_selectedDay);
    if (selectedDayIndex != -1) {
      _dayController.jumpTo(0.1);
      _dayController.jumpTo(selectedDayIndex * _config.itemExtent);
    } else {
      _dayController.jumpTo(0.1);
      _dayController.jumpTo(0);
    }
  }

  @override
  void dispose() {
    _yearController.dispose();
    _monthController.dispose();
    _dayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollUpdateNotification) {
          DateTime date = DateTime.parse("$_selectedYear-${dateFormatter(_monthIndex + 1)}-${dateFormatter(_selectedDay)}");
          if (date != _selectedDate) {
            setState(() {
              _selectedDate = date;
            });
            widget.onChanged(DateTime.parse("$_selectedYear-${dateFormatter(_monthIndex + 1)}-${dateFormatter(_selectedDay)}"));
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
                decoration: widget.selectedBoxDecoration,
              ),
            ),
            _koKRDatePicker()
          ],
        ),
      ),
    );
  }

  // Widget _enUSDatePicker() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       _listWheelScrollView(
  //           width: 120.0,
  //           controller: _monthController,
  //           itemIndex: _monthIndex,
  //           item: _month,
  //           selectedItemChanged: (value) {
  //             setState(() {
  //               _monthIndex = value;
  //               _selectedMonth = _month[value];
  //               _day = [for (int i = 1; i <= getMonthlyDate(month: _monthIndex + 1, year: _selectedYear); i++) i];
  //             });
  //             _updateDay();
  //           }),
  //       SizedBox(
  //         width: 16.0,
  //       ),
  //       _listWheelScrollView(
  //           width: 40.0,
  //           controller: _dayController,
  //           itemIndex: _dayIndex,
  //           item: _day,
  //           selectedItemChanged: (value) {
  //             setState(() {
  //               _dayIndex = value;
  //               _selectedDay = _day[value];
  //             });
  //           }),
  //       SizedBox(
  //         width: 16.0,
  //       ),
  //       _listWheelScrollView(
  //           width: 70.0,
  //           controller: _yearController,
  //           itemIndex: _yearIndex,
  //           item: _year,
  //           selectedItemChanged: (value) {
  //             setState(() {
  //               _yearIndex = value;
  //               _selectedYear = _year[value];
  //               _day = [for (int i = 1; i <= getMonthlyDate(month: _monthIndex + 1, year: _selectedYear); i++) i];
  //             });
  //             _updateDay();
  //           }),
  //     ],
  //   );
  // }

  Widget _koKRDatePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DateScrollView(
          width: 70.0,
          controller: _yearController,
          itemIndex: _yearIndex,
          item: _year,
          config: _config,
          isLoop: widget.isLoop,
          label: "년",
          onChanged: (value) {
            setState(() {
              _yearIndex = value;
              _selectedYear = _year[value];
              _day = [for (int i = 1; i <= getMonthlyDate(month: _monthIndex + 1, year: _selectedYear); i++) i];
            });
            _updateDay();
          },
        ),
        SizedBox(
          width: 16.0,
        ),
        DateScrollView(
            width: 45.0,
            controller: _monthController,
            itemIndex: _monthIndex,
            item: _month,
            config: _config,
            isLoop: widget.isLoop,
            label: "월",
            onChanged: (value) {
              setState(() {
                _monthIndex = value;
                _selectedMonth = _month[value];
                _day = [for (int i = 1; i <= getMonthlyDate(month: _monthIndex + 1, year: _selectedYear); i++) i];
              });
              _updateDay();
            }),
        SizedBox(
          width: 16.0,
        ),
        DateScrollView(
            width: 45.0,
            controller: _dayController,
            itemIndex: _dayIndex,
            item: _day,
            config: _config,
            isLoop: widget.isLoop,
            label: "일",
            onChanged: (value) {
              setState(() {
                _dayIndex = value;
                _selectedDay = _day[value];
              });
            }),
      ],
    );
  }
}
