import 'package:flutter/material.dart';

enum DatePickerLocale {
  en_us,
  ko_kr,
}

class ScrollDatePicker extends StatefulWidget {
  ScrollDatePicker({
    Key key,
    this.height = 300.0,
    this.minimumYear = 2000,
    this.maximumYear = 2100,
    this.initialDateTime,
    this.selectedTextStyle = const TextStyle(
        fontSize: 20.0, color: Colors.black, fontWeight: FontWeight.w500),
    this.mainTextStyle = const TextStyle(fontSize: 18.0, color: Colors.grey),
    this.onChanged,
    this.itemExtent = 37.0,
    this.diameterRatio = 3.0,
    this.perspective = 0.01,
    this.selectedBoxDecoration = const BoxDecoration(color: Colors.black12),
    this.isLoop = true,
    this.locale = DatePickerLocale.ko_kr,
  })  : assert(itemExtent != null),
        assert(itemExtent > 0),
        assert(initialDateTime != null),
        super(key: key);

  /// Minimum year that the picker can be scrolled
  final int minimumYear;

  /// Maximum year that the picker can be scrolled
  final int maximumYear;

  /// The initial date and/or time of the picker.
  final DateTime initialDateTime;

  /// An opaque object that determines the size, position, and rendering of selected text.
  final TextStyle selectedTextStyle;

  /// An opaque object that determines the size, position, and rendering of text.
  final TextStyle mainTextStyle;

  /// On optional listener that's called when the centered item changes.
  final ValueChanged<DateTime> onChanged;

  /// If non-null, requires the child to have exactly this height.
  final double height;

  /// Size of each child in the main axis
  final double itemExtent;

  /// {@macro flutter.rendering.wheelList.diameterRatio}
  final double diameterRatio;

  /// {@macro flutter.rendering.wheelList.perspective}
  final double perspective;

  /// An immutable description of how to paint a box.
  final BoxDecoration selectedBoxDecoration;

  /// The loop iterates on an explicit list of values
  final bool isLoop;

  /// Set calendar language
  final DatePickerLocale locale;

  @override
  _ScrollDatePickerState createState() => _ScrollDatePickerState();
}

class _ScrollDatePickerState extends State<ScrollDatePicker> {
  FixedExtentScrollController _yearController;
  FixedExtentScrollController _monthController;
  FixedExtentScrollController _dayController;

  List month = [];
  List<int> day = [];
  List<int> year = [];

  int selectedYear = 0;
  var selectedMonth;
  int selectedDay = 0;

  int monthIndex = 0;
  int dayIndex = 0;
  int yearIndex = 0;

  DateTime selectedDate;

  @override
  void initState() {
    super.initState();

    year = [for (int i = widget.minimumYear; i <= widget.maximumYear; i++) i];
    if (widget.locale == DatePickerLocale.ko_kr) {
      month = [for (int i = 1; i <= 12; i++) i];
    } else {
      month = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
    }

    selectedYear = widget.initialDateTime.year;
    selectedMonth = widget.initialDateTime.month;
    selectedDay = widget.initialDateTime.day;
    day = [for (int i = 1; i <= getMonthlyDate(selectedMonth); i++) i];

    yearIndex = year.indexOf(selectedYear);
    monthIndex = month.indexOf(selectedMonth);
    dayIndex = day.indexOf(selectedDay);

    _yearController = FixedExtentScrollController(initialItem: yearIndex);
    _monthController = FixedExtentScrollController(initialItem: monthIndex);
    _dayController = FixedExtentScrollController(initialItem: dayIndex);
  }

  int getMonthlyDate(int month) {
    int day = 0;

    switch (month) {
      case 1:
        day = 31;
        break;
      case 2:
        day = (selectedYear % 4 == 0 && selectedYear % 100 != 0) ||
                selectedYear % 400 == 0
            ? 29
            : 28;
        break;
      case 3:
        day = 31;
        break;
      case 4:
        day = 30;
        break;
      case 5:
        day = 31;
        break;
      case 6:
        day = 30;
        break;
      case 7:
        day = 31;
        break;
      case 8:
        day = 31;
        break;
      case 9:
        day = 30;
        break;
      case 10:
        day = 31;
        break;
      case 11:
        day = 30;
        break;
      case 12:
        day = 31;
        break;

      default:
        day = 30;
        break;
    }

    return day;
  }

  void updateDay() {
    int selectedDayIndex = day.indexOf(selectedDay);
    if (selectedDayIndex != -1) {
      _dayController.jumpTo(0.1);
      _dayController.jumpTo(selectedDayIndex * widget.itemExtent);
    } else {
      _dayController.jumpTo(0.1);
      _dayController.jumpTo(0);
    }
  }

  String dateFormatter(int value) {
    return value.toString().length > 1 ? value.toString() : "0$value";
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
          if (widget.onChanged != null) {
            DateTime date = DateTime.parse(
                "$selectedYear-${dateFormatter(monthIndex + 1)}-${dateFormatter(selectedDay)}");
            if (date != selectedDate) {
              setState(() {
                selectedDate = date;
              });
              widget.onChanged(DateTime.parse(
                  "$selectedYear-${dateFormatter(monthIndex + 1)}-${dateFormatter(selectedDay)}"));
            }
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
                height: widget.itemExtent,
                decoration: widget.selectedBoxDecoration,
              ),
            ),
            widget.locale == DatePickerLocale.ko_kr
                ? koKRDatePicker()
                : enUSDatePicker(),
          ],
        ),
      ),
    );
  }

  Widget enUSDatePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        listWheelScrollView(
            width: 120.0,
            controller: _monthController,
            itemIndex: monthIndex,
            item: month,
            selectedItemChanged: (value) {
              setState(() {
                monthIndex = value;
                selectedMonth = month[value];
                day = [
                  for (int i = 1; i <= getMonthlyDate(monthIndex + 1); i++) i
                ];
              });
              updateDay();
            }),
        SizedBox(
          width: 16.0,
        ),
        listWheelScrollView(
            width: 40.0,
            controller: _dayController,
            itemIndex: dayIndex,
            item: day,
            selectedItemChanged: (value) {
              setState(() {
                dayIndex = value;
                selectedDay = day[value];
              });
            }),
        SizedBox(
          width: 16.0,
        ),
        listWheelScrollView(
            width: 70.0,
            controller: _yearController,
            itemIndex: yearIndex,
            item: year,
            selectedItemChanged: (value) {
              setState(() {
                yearIndex = value;
                selectedYear = year[value];
                day = [
                  for (int i = 1; i <= getMonthlyDate(monthIndex + 1); i++) i
                ];
              });
              updateDay();
            }),
      ],
    );
  }

  Widget koKRDatePicker() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        listWheelScrollView(
            width: 70.0,
            controller: _yearController,
            itemIndex: yearIndex,
            item: year,
            dateFormat: "년",
            selectedItemChanged: (value) {
              setState(() {
                yearIndex = value;
                selectedYear = year[value];
                day = [
                  for (int i = 1; i <= getMonthlyDate(selectedMonth); i++) i
                ];
              });
              updateDay();
            }),
        SizedBox(
          width: 16.0,
        ),
        listWheelScrollView(
            width: 45.0,
            controller: _monthController,
            itemIndex: monthIndex,
            item: month,
            dateFormat: "월",
            selectedItemChanged: (value) {
              setState(() {
                monthIndex = value;
                selectedMonth = month[value];
                day = [
                  for (int i = 1; i <= getMonthlyDate(selectedMonth); i++) i
                ];
              });
              updateDay();
            }),
        SizedBox(
          width: 16.0,
        ),
        listWheelScrollView(
            width: 45.0,
            controller: _dayController,
            itemIndex: dayIndex,
            item: day,
            dateFormat: "일",
            selectedItemChanged: (value) {
              setState(() {
                dayIndex = value;
                selectedDay = day[value];
              });
            }),
      ],
    );
  }

  Widget listWheelScrollView(
      {double width,
      ValueChanged<int> selectedItemChanged,
      int itemIndex,
      List item,
      String dateFormat = "",
      FixedExtentScrollController controller}) {
    return widget.isLoop
        ? Container(
            width: width,
            child: ListWheelScrollView.useDelegate(
              itemExtent: widget.itemExtent,
              diameterRatio: widget.diameterRatio,
              controller: controller,
              physics: FixedExtentScrollPhysics(),
              perspective: widget.perspective,
              onSelectedItemChanged: selectedItemChanged,
              childDelegate: ListWheelChildLoopingListDelegate(
                children: List<Widget>.generate(
                  item.length,
                  (index) => Container(
                    alignment: Alignment.centerLeft,
                    child: Text("${item[index]}$dateFormat",
                        style: itemIndex == index
                            ? widget.selectedTextStyle
                            : widget.mainTextStyle),
                  ),
                ),
              ),
            ),
          )
        : Container(
            width: width,
            child: ListWheelScrollView(
              itemExtent: widget.itemExtent,
              diameterRatio: widget.diameterRatio,
              controller: controller,
              physics: FixedExtentScrollPhysics(),
              perspective: widget.perspective,
              onSelectedItemChanged: selectedItemChanged,
              children: List<Widget>.generate(
                item.length,
                (index) => Container(
                  alignment: Alignment.centerLeft,
                  child: Text("${item[index]}$dateFormat",
                      style: itemIndex == index
                          ? widget.selectedTextStyle
                          : widget.mainTextStyle),
                ),
              ),
            ),
          );
  }
}
