import 'package:intl/intl.dart';

String formatLongDate(DateTime date) {
  final DateFormat formatter = DateFormat('EEEE, MMMM d, y hh:mm a');
  return formatter.format(date);
}

String formatDate(DateTime date) {
  final DateFormat formatter = DateFormat('MMMM d, y');
  return formatter.format(date);
}

String formatShortDate(DateTime date) {
  final DateFormat formatter = DateFormat('MM/dd/yyyy');
  return formatter.format(date);
}

String formatTime(DateTime date) {
  final DateFormat formatter = DateFormat('hh:mm a');
  return formatter.format(date);
}

String formatLongTime(DateTime date) {
  final DateFormat formatter = DateFormat('HH:mm:ss');
  return formatter.format(date);
}

bool checkDate(DateTime date, DateTime checkedDate) {
  return date.year == checkedDate.year &&
      date.month == checkedDate.month &&
      date.day == checkedDate.day;
}

bool checkGreaterDate(DateTime date, DateTime checkedDate) {
  return checkedDate.millisecondsSinceEpoch > date.millisecondsSinceEpoch;
}

bool checkLessDate(DateTime date, DateTime checkedDate) {
  return checkedDate.millisecondsSinceEpoch < date.millisecondsSinceEpoch;
}

DateTime createDate(int month, int day, int year) {
  return DateTime(year, month, day);
}

List<int> getDaysOfMonth(int month, int year) {
  // Validate month input
  if (month < 1 || month > 12) {
    throw ArgumentError(
        'Invalid month: $month. Month must be between 1 and 12.');
  }

  // Determine number of days in the month
  int daysInMonth = 31; // Default to maximum days

  switch (month) {
    case 4: // April
    case 6: // June
    case 9: // September
    case 11: // November
      daysInMonth = 30;
      break;
    case 2: // February
      daysInMonth = _isLeapYear(year) ? 29 : 28;
      break;
  }

  // Create list of days in the month
  List<int> daysList = List.generate(daysInMonth, (index) => index + 1);

  return daysList;
}

bool _isLeapYear(int year) {
  if (year % 4 != 0) {
    return false;
  } else if (year % 100 != 0) {
    return true;
  } else if (year % 400 != 0) {
    return false;
  } else {
    return true;
  }
}

int daysBetweenDates(DateTime date1, DateTime date2) {
  // Calculate difference in milliseconds
  Duration difference = date1.difference(date2).abs();

  // Calculate difference in days
  int diffDays = difference.inDays;

  return diffDays;
}

DateTime startOfDay(DateTime date) {
  return DateTime.utc(date.year, date.month, date.day);
}

DateTime endOfDay(DateTime date) {
  return DateTime.utc(date.year, date.month, date.day, 23, 59, 59, 999);
}
