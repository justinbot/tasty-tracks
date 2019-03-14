import 'package:intl/intl.dart';

String formatDate(String date, String datePrecision) {
  switch (datePrecision) {
    case 'year':
      return DateFormat.y().format(DateTime.parse(date + '-01-01'));
    case 'month':
      return DateFormat.yMMM().format(DateTime.parse(date + '-01'));
    case 'day':
      return DateFormat.yMMMd().format(DateTime.parse(date));
    default:
      return '';
  }
}
