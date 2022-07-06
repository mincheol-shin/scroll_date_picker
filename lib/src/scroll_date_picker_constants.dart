import 'package:flutter/cupertino.dart';

const String ko = 'ko';
const String fr = 'fr';
const String de = 'de';
const String vi = 'vi';
const String en = 'en';

extension LocaleExtension on Locale {
  List<String> get months {
    List<String> _months = [];
    switch (languageCode) {
      case ko:
        _months = koMonths;
        break;
      case fr:
        _months = frMonths;
        break;
      case de:
        _months = deMonths;
        break;
      case vi:
        _months = viMonths;
        break;
      default:
        _months = enMonths;
    }
    return _months;
  }
}

const List<String> koMonths = [
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
  '12',
];
const List<String> enMonths = [
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
  'December',
];
const List<String> frMonths = [
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
  'Décembre',
];
const List<String> deMonths = [
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
  'Dezember',
];

const List<String> viMonths = [
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
