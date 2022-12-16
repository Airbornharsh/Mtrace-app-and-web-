class Time {
  final int second;
  final int minute;
  final int hour;
  final int day;
  final int month;
  final int weekDay;
  final int year;
  final DateTime time;

  Time(
      {required this.second,
      required this.minute,
      required this.hour,
      required this.day,
      required this.month,
      required this.weekDay,
      required this.year,
      required this.time});
}

class Expense {
  final String id;
  final String title;
  final double amount;
  final String category;
  final String emailId;
  final Time time;

  Expense(
      {required this.id,
      required this.title,
      required this.amount,
      required this.category,
      required this.emailId,
      required this.time});
}

enum Filter {
  newestFirst,
  oldestFirst,
  lowToHigh,
  highToLow,
}
