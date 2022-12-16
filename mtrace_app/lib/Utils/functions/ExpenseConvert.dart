import 'package:mtrace_app/Utils/Structure.dart';

Expense expenseConvert(dynamic data) {
  late Expense expense;

  Expense easyConvert(int min, int hour, int day) {
    return Expense(
        id: data["_id"],
        title: data["title"],
        amount: data["amount"].toDouble(),
        category: data["category"],
        emailId: data["emailId"],
        time: Time(
            second: DateTime.parse(data["time"]).second,
            minute: DateTime.parse(data["time"]).minute + min,
            hour: DateTime.parse(data["time"]).hour + hour,
            day: DateTime.parse(data["time"]).day + day,
            month: DateTime.parse(data["time"]).month,
            weekDay: DateTime.parse(data["time"]).weekday,
            year: DateTime.parse(data["time"]).year,
            time: DateTime.parse(data["time"])));
  }

  if (DateTime.parse(data["time"]).minute + 30 > 60) {
    if (DateTime.parse(data["time"]).hour + 5 + 1 > 24) {
      expense = easyConvert(-30, -18, 1);
    } else {
      expense = easyConvert(-30, 6, 0);
    }
  } else {
    if (DateTime.parse(data["time"]).hour + 5 + 1 > 24) {
      expense = easyConvert(30, -19, 1);
    } else {
      expense = easyConvert(30, 5, 0);
    }
  }
  return expense;
}

Expense offlineExpenseConvert(dynamic data) {
  late Expense expense;

  Expense easyConvert(int min, int hour, int day) {
    return Expense(
        id: data["id"],
        title: data["title"],
        amount: data["amount"].toDouble(),
        category: data["category"],
        emailId: "",
        time: Time(
            second: DateTime.parse(data["time"]).second,
            minute: DateTime.parse(data["time"]).minute + min,
            hour: DateTime.parse(data["time"]).hour + hour,
            day: DateTime.parse(data["time"]).day + day,
            month: DateTime.parse(data["time"]).month,
            weekDay: DateTime.parse(data["time"]).weekday,
            year: DateTime.parse(data["time"]).year,
            time: DateTime.parse(data["time"])));
  }

  if (DateTime.parse(data["time"]).minute + 30 > 60) {
    if (DateTime.parse(data["time"]).hour + 5 + 1 > 24) {
      expense = easyConvert(-30, -18, 1);
    } else {
      expense = easyConvert(-30, 6, 0);
    }
  } else {
    if (DateTime.parse(data["time"]).hour + 5 + 1 > 24) {
      expense = easyConvert(30, -19, 1);
    } else {
      expense = easyConvert(30, 5, 0);
    }
  }
  return expense;
}
