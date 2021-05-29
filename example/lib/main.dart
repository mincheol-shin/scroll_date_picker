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
  late DatePickerController _controller;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _controller = DatePickerController(
        year: _selectedDate.year,
        month: _selectedDate.month,
        day: _selectedDate.day,
        minYear: 2011,
        maxYear: 2050);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            controller: _controller,
            initialDateTime: DateTime.now(),
            locale: DatePickerLocale.ko_kr,
            pickerDecoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent, width: 2.0)),
            config: DatePickerConfig(
                isLoop: true,
                selectedTextStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontSize: 17.0)),
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
