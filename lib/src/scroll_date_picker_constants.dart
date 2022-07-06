import 'package:flutter/cupertino.dart';
import 'package:scroll_date_picker/src/models/date_picker_scroll_view_options.dart';

const List<String> koKrMonths = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'];
const List<String> enUsMonths = ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'];
const List<String> frFrMonths = ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'];
const List<String> deDeMonths = ['Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'July', 'August', 'September', 'Oktober', 'November', 'Dezember'];

const List<String> viVnMonths = [
  'Tháng 1',
  'Tháng 2',
  'Tháng 3',
  'Tháng 4',
  'Tháng 5',
  'Tháng 6',
  'Tháng 7',
  'Tháng 8',
  'Tháng 9',
  'Tháng 10',
  'Tháng 11',
  'Tháng 12',
];

enum DatePickerLocale {
  enUS,
  koKR,
  frFR,
  deDE,
  viVN,
}

extension DatePickerLocaleExtension on DatePickerLocale {
  List<String> pickerMonthsInGivenYear(List<int> months) {
    List<String> _months = [];
    switch (this) {
      case DatePickerLocale.koKR:
        _months = koKrMonths;
        break;
      case DatePickerLocale.frFR:
        _months = frFrMonths;
        break;
      case DatePickerLocale.deDE:
        _months = deDeMonths;
        break;
      case DatePickerLocale.viVN:
        _months = viVnMonths;
        break;
      default:
        _months = enUsMonths;
    }
    return _months.sublist(months.first - 1, months.last);
  }

  DatePickerScrollViewOptions get scrollViewOptions {
    switch (this) {
      case DatePickerLocale.koKR:
        return DatePickerScrollViewOptions(
          year: ScrollViewDetailOptions(
            label: '년',
            margin: const EdgeInsets.only(right: 8),
          ),
          month: ScrollViewDetailOptions(
            label: '월',
            margin: const EdgeInsets.only(right: 16),
          ),
          day: ScrollViewDetailOptions(
            label: '일',
          ),
        );
      default:
        return DatePickerScrollViewOptions();
    }
  }
}
