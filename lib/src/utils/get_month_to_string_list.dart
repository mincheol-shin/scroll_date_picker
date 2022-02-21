import 'package:scroll_date_picker/scroll_date_picker.dart';

List<String> getMonthsToStringList({required List<int> months, required DatePickerLocale locale}) {
  List<String> _months = [];
  switch (locale) {
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
