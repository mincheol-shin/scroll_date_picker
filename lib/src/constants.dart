import 'package:flutter/cupertino.dart';

const String ko = 'ko';
const String fr = 'fr';
const String de = 'de';
const String vi = 'vi';
const String en = 'en';
const String id = 'id';
const String th = 'th';

extension LocaleExtension on Locale {
  List<String> get months {
    switch (languageCode) {
      case ko:
        return koMonths;
      case fr:
        return frMonths;
      case de:
        return deMonths;
      case vi:
        return viMonths;
      case id:
        return idMonths;
      case th:
        return thMonths;
      default:
        return enMonths;
    }
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

const List<String> idMonths = [
  'Januari',
  'Februari',
  'Maret',
  'April',
  'Mei',
  'Juni',
  'Juli',
  'Agustus',
  'September',
  'Oktober',
  'November',
  'Desember',
];
const List<String> thMonths = [
  'มกราคม',
  'กุมภาพันธ์',
  'มีนาคม',
  'เมษายน',
  'พฤษภาคม',
  'มิถุนายน',
  'กรกฎาคม',
  'สิงหาคม',
  'กันยายน',
  'ตุลาคม',
  'พฤศจิกายน',
  'ธันวาคม',
];
