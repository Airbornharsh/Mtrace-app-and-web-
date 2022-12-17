import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:mtrace_app/Utils/Structure.dart';
import 'package:mtrace_app/Utils/functions/ExpenseConvert.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Expenses with ChangeNotifier {
  List<Expense> _items = [];
  Map<String, Map<String, Object>> _categoryItems = {};
  Filter filter = Filter.newestFirst;

  Filter get getFilter {
    return filter;
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

    late List<Expense> tempCategoryItems;

    if (_categoryItems.containsKey(category)) {
      tempCategoryItems = _categoryItems[category]!["list"] as List<Expense>;
    }

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
}
