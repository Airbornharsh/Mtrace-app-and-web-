import 'package:flutter/cupertino.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:mtrace_app/Utils/Structure.dart';
import 'package:mtrace_app/Utils/functions/ExpenseConvert.dart';

class OfflineExpenses with ChangeNotifier {
  List<Expense> _items = [];
  Map<String, Map<String, Object>> _categoryItems = {};
  Filter filter = Filter.newestFirst;
  final Box _box = Hive.box("mtraceExpenseBox");

  void onLoad() {
    _items = [];
    var expenseItems = _box.get("expenseItems");
    if (expenseItems != null) {
      expenseItems.forEach((expenseId) {
        var expenseData = _box.get(expenseId);
        if (expenseData != null) {
          Expense expense = offlineExpenseConvert(expenseData);
          _items.add(expense);
        }
      });
    }

    // _box.delete("expenseItems");
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

  Future<bool> addExpenseOffline(
      String category, String title, double amount) async {
    String dateTimeNow = DateTime.now().toIso8601String();

    try {
      var expenseData = {
        "id": "${category}_$dateTimeNow",
        "title": title,
        "amount": amount,
        "category": category,
        "time": dateTimeNow
      };

      if (_box.containsKey("expenseItems")) {
        var expenseItems = _box.get("expenseItems");
        expenseItems.add(expenseData["id"]);
        _box.put(expenseData["id"], expenseData);
        _box.put("expenseItems", expenseItems);
      } else {
        _box.put(expenseData["id"], expenseData);
        _box.put("expenseItems", [expenseData["id"]]);
      }

      late Expense expense;

      expense = offlineExpenseConvert(expenseData);

      _items.insert(0, expense);

      if (_categoryItems.containsKey(category)) {
        (_categoryItems[category]!["list"] as List<Expense>).insert(0, expense);
      } else {
        _categoryItems[category] = {
          "filter": Filter.newestFirst,
          "list": [expense]
        };
      }

      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> editExpenseOffline(
      String category, String id, String title, double amount) async {
    try {
      var expenseData = _box.get(id);

      expenseData["title"] = title;
      expenseData["amount"] = amount;

      _box.put(id, expenseData);

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

      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      notifyListeners();
    }
  }

  Future<bool> deleteExpenseOffline(String category, String id) async {
    try {
      _box.delete(id);

      var expenseItemsId = _box.get("expenseItems");
      expenseItemsId.removeWhere((e) => e == id);
      _box.put("expenseItems", expenseItemsId);

      (_categoryItems[category]!["list"] as List<Expense>)
          .removeWhere((e) => e.id == id);

      _items.removeWhere((e) => e.id == id);

      return true;
    } catch (e) {
      return false;
    } finally {
      notifyListeners();
    }
  }
}
