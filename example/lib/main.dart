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
  DateTime selectedDate = DateTime.now();

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
              "$selectedDate",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
            ),
          ),
          ScrollDatePicker(
            itemExtent: 45.0,
            minimumYear: 2010,
            maximumYear: 2050,
            initialDateTime: DateTime.parse("2020-05-01"),
            isLoop: false,
            locale: DatePickerLocale.ko_kr,
            selectedBoxDecoration: BoxDecoration(border: Border.all(color: Colors.blueAccent, width: 2.0)),
            onChanged: (value) {
              setState(() {
                selectedDate = value;
              });
            },
          ),
        ],
      ),
    );
  }
}
