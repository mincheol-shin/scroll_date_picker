import 'package:flutter/material.dart';

class DatePickerIndicator extends StatelessWidget {
  const DatePickerIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
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
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 40,
            width: double.infinity,
            color: Colors.grey.withOpacity(0.2),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
