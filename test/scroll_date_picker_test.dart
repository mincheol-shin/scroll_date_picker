import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:scroll_date_picker/src/widgets/date_scroll_view.dart';

void main() {
  group("picker ui validation", () {
    testWidgets("when viewType is empty then shows default view for the locale",
        (tester) async {
      final selectedDate = DateTime(2021, 3, 5);

      final targetView = MaterialApp(
        home: ScrollDatePicker(
          locale: Locale("en"),
          selectedDate: selectedDate,
          onDateTimeChanged: (DateTime value) {
            //do nothing
          },
          viewType: [],
        ),
      );

      await tester.pumpWidget(targetView);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byType(DateScrollView), findsNWidgets(3));
    });

    testWidgets("when viewType is null then shows default view for the locale",
        (tester) async {
      final selectedDate = DateTime(2021, 3, 5);

      final targetView = MaterialApp(
        home: ScrollDatePicker(
          locale: Locale("en"),
          selectedDate: selectedDate,
          onDateTimeChanged: (DateTime value) {
            //do nothing
          },
          viewType: null,
        ),
      );

      await tester.pumpWidget(targetView);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byType(DateScrollView), findsNWidgets(3));
    });

    testWidgets(
        "when viewType is not null or empty, then shows viewType list length's DateScrollView",
        (tester) async {
      final selectedDate = DateTime(2021, 3, 5);

      final targetView = MaterialApp(
        home: ScrollDatePicker(
          locale: Locale("en"),
          selectedDate: selectedDate,
          onDateTimeChanged: (DateTime value) {
            //do nothing
          },
          viewType: [DatePickerViewType.month],
        ),
      );

      await tester.pumpWidget(targetView);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byType(DateScrollView), findsNWidgets(1));
      expect(find.byKey(const Key("month")), findsOneWidget);
    });

    testWidgets(
        "when viewType is not null or empty, then shows viewType list length's DateScrollView",
        (tester) async {
      final selectedDate = DateTime(2021, 3, 5);

      final targetView = MaterialApp(
        home: ScrollDatePicker(
          locale: Locale("en"),
          selectedDate: selectedDate,
          onDateTimeChanged: (DateTime value) {
            //do nothing
          },
          viewType: [
            DatePickerViewType.month,
            DatePickerViewType.year,
            DatePickerViewType.day
          ],
        ),
      );

      await tester.pumpWidget(targetView);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byType(DateScrollView), findsNWidgets(3));
      expect(find.byKey(const Key("month")), findsOneWidget);
      expect(find.byKey(const Key("year")), findsOneWidget);
      expect(find.byKey(const Key("day")), findsOneWidget);
    });

    testWidgets(
        "when viewType is not null or empty, then shows viewType list length's DateScrollView",
        (tester) async {
      final selectedDate = DateTime(2021, 3, 5);

      final targetView = MaterialApp(
        home: ScrollDatePicker(
          locale: Locale("en"),
          selectedDate: selectedDate,
          onDateTimeChanged: (DateTime value) {
            //do nothing
          },
          viewType: [DatePickerViewType.year, DatePickerViewType.day],
        ),
      );

      await tester.pumpWidget(targetView);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byType(DateScrollView), findsNWidgets(2));
      expect(find.byKey(const Key("year")), findsOneWidget);
      expect(find.byKey(const Key("day")), findsOneWidget);
    });

    testWidgets(
        "when viewType is not null or empty, then shows viewType list length's DateScrollView",
        (tester) async {
      final selectedDate = DateTime(2021, 3, 5);

      final targetView = MaterialApp(
        home: ScrollDatePicker(
          locale: Locale("en"),
          selectedDate: selectedDate,
          onDateTimeChanged: (DateTime value) {
            //do nothing
          },
          viewType: [DatePickerViewType.month, DatePickerViewType.day],
        ),
      );

      await tester.pumpWidget(targetView);
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.byType(DateScrollView), findsNWidgets(2));
      expect(find.byKey(const Key("month")), findsOneWidget);
      expect(find.byKey(const Key("day")), findsOneWidget);
    });
  });
}
