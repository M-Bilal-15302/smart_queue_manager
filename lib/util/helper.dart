import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  return DateFormat('MMM d, y - hh:mm a').format(dateTime);
}

String formatTime(DateTime dateTime) {
  return DateFormat('hh:mm a').format(dateTime);
}