import 'package:flutter/material.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

void main() {
  runApp(MaterialApp(home: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DateTime _selectedDate = DateTime.now();

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
            height: 100.0,
            alignment: Alignment.center,
            child: Text(
              "$_selectedDate",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w500),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedDate = _selectedDate.add(Duration(days: -5));
                  });
                },
                icon: const Icon(Icons.remove),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    _selectedDate = _selectedDate.add(Duration(days: 5));
                  });
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          Expanded(
            child: ScrollDatePicker(
              selectedDate: _selectedDate,
              onDateTimeChanged: (DateTime value) {
                setState(() {
                  _selectedDate = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
