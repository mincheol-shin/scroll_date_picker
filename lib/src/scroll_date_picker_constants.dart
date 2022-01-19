import 'package:flutter/cupertino.dart';
import 'package:scroll_date_picker/src/models/date_picker_locale_options.dart';

const List<String> koKrMonths = [
  '1',
  '2',
  '3',
  '4',
  '5',
  '6',
  '7',
  '8',
  '9',
  '10',
  '11',
  '12'
];
const List<String> enUsMonth = [
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
const List<String> frFrMonth = [
  'Janvier',
  'Février',
  'Mars',
  'Avril',
  'Mai',
  'Juin',
  'Juillet',
  'Août',
  'Septembre',
  'Octobre',
  'Novembre',
  'Décembre'
];
const List<String> deDeMonth = [
  'Januar',
  'Februar',
  'März',
  'April',
  'Mai',
  'Juni',
  'July',
  'August',
  'September',
  'Oktober',
  'November',
  'Dezember'
];

enum DatePickerLocale {
  en_us,
  ko_kr,
  fr_fr,
  de_de,
}

extension DatePickerLocaleExtension on DatePickerLocale {
  List<String> get month {
    switch (this) {
      case DatePickerLocale.ko_kr:
        return koKrMonths;
      case DatePickerLocale.fr_fr:
        return frFrMonth;
      case DatePickerLocale.de_de:
        return deDeMonth;
      default:
        return [
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
  }

  DatePickerLocaleOptions get localeOptions {
    switch (this) {
      case DatePickerLocale.ko_kr:
        return DatePickerLocaleOptions(
            yearLabel: "년", monthLabel: "월", dayLabel: "일");
      default:
        return DatePickerLocaleOptions(
            monthAlignment: Alignment.centerLeft,
            monthWidth: 100,
            yearWidth: 60,
            dayWidth: 60);
    }
  }
}
