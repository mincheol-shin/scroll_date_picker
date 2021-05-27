import 'package:flutter/material.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late FixedExtentScrollController _yearController;
  late FixedExtentScrollController _monthController;
  late FixedExtentScrollController _dayController;

  DateTime _selectedDate = DateTime.now();

  int _minimumYear = 2010;
  int _maximumYear = 2050;

  @override
  void initState() {
    super.initState();

    _yearController = FixedExtentScrollController(
        initialItem: _selectedDate.year - _minimumYear);
    _monthController =
        FixedExtentScrollController(initialItem: _selectedDate.month - 1);
    _dayController =
        FixedExtentScrollController(initialItem: _selectedDate.day - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Scroll Date Picker Example"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            height: 150.0,
            alignment: Alignment.center,
            child: Text(
              "$_selectedDate",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
            ),
          ),
          ScrollDatePicker(
            yearController: _yearController,
            monthController: _monthController,
            dayController: _dayController,
            minYear: _minimumYear,
            maxYear: _maximumYear,
            initDateTime: DateTime.now(),
            isLoop: true,
            locale: DatePickerLocale.ko_kr,
            selectedBoxDecoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent, width: 2.0)),
            onChanged: (value) {
              setState(() {
                _selectedDate = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
