import 'package:intl/intl.dart';

String formatDate(int date) {
  DateTime dateTime = new DateTime.fromMillisecondsSinceEpoch(date);
  final format = new DateFormat("yMd");
  return format.format(dateTime);
}
