import 'package:intl/intl.dart';

class DateTimeUtils {
  DateTimeUtils._(); // Private constructor for utility class

  /// Parse time string (HH:mm) to DateTime
  static DateTime parseTime(String time, {DateTime? baseDate}) {
    final parts = time.split(':');
    if (parts.length != 2) {
      throw FormatException('Invalid time format: $time');
    }

    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);

    final base = baseDate ?? DateTime.now();
    return DateTime(base.year, base.month, base.day, hour, minute);
  }

  /// Format DateTime to time string (HH:mm)
  static String formatTime(DateTime dateTime) {
    return DateFormat('HH:mm').format(dateTime);
  }

  /// Format DateTime to 12-hour format (hh:mm a)
  static String formatTime12Hour(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  /// Get time difference in human-readable format
  static String getTimeDifference(DateTime from, DateTime to) {
    final difference = to.difference(from);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ${difference.inHours % 24}h';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ${difference.inMinutes % 60}m';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return '${difference.inSeconds}s';
    }
  }

  /// Check if two dates are on the same day
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Get list of dates between two dates
  static List<DateTime> getDaysBetween(DateTime start, DateTime end) {
    final days = <DateTime>[];
    var current = DateTime(start.year, start.month, start.day);
    final endDate = DateTime(end.year, end.month, end.day);

    while (current.isBefore(endDate) || current.isAtSameMomentAs(endDate)) {
      days.add(current);
      current = current.add(const Duration(days: 1));
    }

    return days;
  }

  /// Get week day name
  static String getWeekdayName(int weekday) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return weekdays[weekday - 1];
  }

  /// Get month name
  static String getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December',
    ];
    return months[month - 1];
  }
}
