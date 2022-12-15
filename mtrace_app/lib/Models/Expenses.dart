import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class Expenses with ChangeNotifier {
  List<Expense> _items = [];
  Map<String, Map<String, Object>> _categoryItems = {};
  Filter filter = Filter.newestFirst;

  Filter get getFilter {
    return filter;
  }

  String weekdayToString(int i) {
    String val = "";
    switch (i) {
      case 1:
        val = "Sun";
        break;
      case 2:
        val = "Mon";
        break;
      case 3:
        val = "Tue";
        break;
      case 4:
        val = "Wed";
        break;
      case 5:
        val = "Thu";
        break;
      case 6:
        val = "Fri";
        break;
      case 7:
        val = "Sat";
        break;

      default:
    }
    return val;
  }

  String monthToString(int i) {
    String val = "";
    switch (i) {
      case 1:
        val = "Jan";
        break;
      case 2:
        val = "Feb";
        break;
      case 3:
        val = "Mar";
        break;
      case 4:
        val = "Apr";
        break;
      case 5:
        val = "May";
        break;
      case 6:
        val = "Jun";
        break;
      case 7:
        val = "Jul";
        break;
      case 8:
        val = "Aug";
        break;
      case 9:
        val = "Sep";
        break;
      case 10:
        val = "Oct";
        break;
      case 11:
        val = "Nov";
        break;
      case 12:
        val = "Dec";
        break;

      default:
    }
    return val;
  }

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

  Future<List<Expense>> onLoad() async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("mtrace_backend_uri") as String;

    try {
      var Res =
          await client.get(Uri.parse("$domainUri/api/expenses/get"), headers: {
        "Content-Type": "application/json",
        "authorization": "bearer ${prefs.getString('mtrace_accessToken')}"
      });

      if (Res.statusCode != 200) {
        throw Res.body;
      }

      var parsedBody = json.decode(Res.body);

      _items.clear();
      parsedBody.forEach((expense) {
        _items.add(expenseConvert(expense));
      });

      // _items = _items.reversed.toList();

      return _items;
    } catch (e) {
      print(e);
      return [];
    } finally {
      client.close();
      notifyListeners();
    }
  }

  void arrangeItems() {
    _categoryItems = {};
    for (var expense in _items) {
      if (_categoryItems.containsKey(expense.category)) {
        (_categoryItems[expense.category]!["list"] as List<Expense>)
            .add(expense);
      } else {
        _categoryItems[expense.category] = {
          "filter": Filter.newestFirst,
          "list": [expense]
        };
      }
    }
    notifyListeners();
  }

  List<Expense> categoryItems(String category) {
    if (_categoryItems.containsKey(category)) {
      return _categoryItems[category]!["list"] as List<Expense>;
    } else {
      return [];
    }
  }

  void filterItems(String category, Filter type) {
    filter = type;
    List<Expense> tempCategoryItems =
        _categoryItems[category]!["list"] as List<Expense>;

    if (type == Filter.newestFirst) {
      for (var i = 0; i < tempCategoryItems.length - 1; i++) {
        for (var j = i + 1; j < tempCategoryItems.length; j++) {
          if (tempCategoryItems[i]
                  .time
                  .time
                  .compareTo(tempCategoryItems[j].time.time) <
              0) {
            var temp = tempCategoryItems[i];
            tempCategoryItems[i] = tempCategoryItems[j];
            tempCategoryItems[j] = temp;
          }
        }
      }
      _categoryItems[category]!["list"] = [...tempCategoryItems];
    } else if (type == Filter.oldestFirst) {
      for (var i = 0; i < tempCategoryItems.length - 1; i++) {
        for (var j = i + 1; j < tempCategoryItems.length; j++) {
          if (tempCategoryItems[i]
                  .time
                  .time
                  .compareTo(tempCategoryItems[j].time.time) >
              0) {
            var temp = tempCategoryItems[i];
            tempCategoryItems[i] = tempCategoryItems[j];
            tempCategoryItems[j] = temp;
          }
        }
      }
      _categoryItems[category]!["list"] = [...tempCategoryItems].toList();
    } else if (type == Filter.lowToHigh) {
      for (var i = 0; i < tempCategoryItems.length - 1; i++) {
        for (var j = i + 1; j < tempCategoryItems.length; j++) {
          if (tempCategoryItems[i].amount >= tempCategoryItems[j].amount) {
            var temp = tempCategoryItems[i];
            tempCategoryItems[i] = tempCategoryItems[j];
            tempCategoryItems[j] = temp;
          }
        }
      }
      _categoryItems[category]!["list"] = [...tempCategoryItems];
    } else if (type == Filter.highToLow) {
      for (var i = 0; i < tempCategoryItems.length - 1; i++) {
        for (var j = i + 1; j < tempCategoryItems.length; j++) {
          if (tempCategoryItems[i].amount < tempCategoryItems[j].amount) {
            var temp = tempCategoryItems[i];
            tempCategoryItems[i] = tempCategoryItems[j];
            tempCategoryItems[j] = temp;
          }
        }
      }
      _categoryItems[category]!["list"] = [...tempCategoryItems].toList();
    }

    notifyListeners();
  }

  Future<bool> addExpense(String category, String title, double amount) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("mtrace_backend_uri") as String;
    var tempParsedBody;

    try {
      var Res = await client.post(Uri.parse("$domainUri/api/expense/post"),
          body: json
              .encode({"title": title, "amount": amount, "category": category}),
          headers: {
            "Content-Type": "application/json",
            "authorization": "bearer ${prefs.getString('mtrace_accessToken')}"
          });

      if (Res.statusCode != 200) {
        throw Res.body;
      }

      var parsedBody = json.decode(Res.body);

      tempParsedBody = parsedBody;

      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      late Expense expense;

      expense = expenseConvert(tempParsedBody);

      _items.insert(0, expense);

      (_categoryItems[tempParsedBody["category"]]?["list"] as List<Expense>)
          .insert(0, expense);

      client.close();
      notifyListeners();
    }
  }

  Future<bool> deleteExpense(String category, String id) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("mtrace_backend_uri") as String;

    try {
      var Res = await client.delete(Uri.parse("$domainUri/api/expense/delete"),
          body: json.encode({"id": id}),
          headers: {
            "Content-Type": "application/json",
            "authorization": "bearer ${prefs.getString('mtrace_accessToken')}"
          });

      if (Res.statusCode != 200) {
        throw Res.body;
      }

      var parsedBody = json.decode(Res.body);

      (_categoryItems[category]!["list"] as List<Expense>)
          .removeWhere((e) => e.id == id);

      _items.removeWhere((e) => e.id == id);

      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      client.close();
      notifyListeners();
    }
  }

  Future<bool> editExpense(
      String category, String id, String title, double amount) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("mtrace_backend_uri") as String;

    try {
      var Res = await client.put(Uri.parse("$domainUri/api/expense/put"),
          body: json.encode({"id": id, "title": title, "amount": amount}),
          headers: {
            "Content-Type": "application/json",
            "authorization": "bearer ${prefs.getString('mtrace_accessToken')}"
          });

      if (Res.statusCode != 200) {
        throw Res.body;
      }

      var expense = (_categoryItems[category]!["list"] as List<Expense>)
          .firstWhere((e) => e.id == id);

      var expenseIndex = (_categoryItems[category]!["list"] as List<Expense>)
          .indexWhere((e) => e.id == id);

      (_categoryItems[category]!["list"] as List<Expense>)[expenseIndex] =
          Expense(
              id: id,
              title: title,
              amount: amount,
              category: category,
              emailId: expense.emailId,
              time: expense.time);

      // _items.removeWhere((e) => e.id == id);

      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      client.close();
      notifyListeners();
    }
  }

  void addExpenseOffline(){
    
  }

}
