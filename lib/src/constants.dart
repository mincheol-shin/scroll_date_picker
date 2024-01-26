import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

const String ko = 'ko';
const String fr = 'fr';
const String de = 'de';
const String vi = 'vi';
const String en = 'en';
const String id = 'id';
const String it = 'it';
const String th = 'th';
const String es = 'es';
const String nl = 'nl';
const String zh = 'zh';
const String ar = 'ar';
const String pt = 'pt';
const String tr = 'tr';

extension LocaleExtension on Locale {
  List<String> get months {
    return localizedMonths(this);
  }
}

List<String> localizedMonths(Locale loc) => [
      DateFormat.MMMM(loc.languageCode).format(DateTime(2000, 01)),
      DateFormat.MMMM(loc.languageCode).format(DateTime(2000, 02)),
      DateFormat.MMMM(loc.languageCode).format(DateTime(2000, 03)),
      DateFormat.MMMM(loc.languageCode).format(DateTime(2000, 04)),
      DateFormat.MMMM(loc.languageCode).format(DateTime(2000, 05)),
      DateFormat.MMMM(loc.languageCode).format(DateTime(2000, 06)),
      DateFormat.MMMM(loc.languageCode).format(DateTime(2000, 07)),
      DateFormat.MMMM(loc.languageCode).format(DateTime(2000, 08)),
      DateFormat.MMMM(loc.languageCode).format(DateTime(2000, 09)),
      DateFormat.MMMM(loc.languageCode).format(DateTime(2000, 10)),
      DateFormat.MMMM(loc.languageCode).format(DateTime(2000, 11)),
      DateFormat.MMMM(loc.languageCode).format(DateTime(2000, 12)),
    ];
