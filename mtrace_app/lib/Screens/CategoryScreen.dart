import 'package:flutter/material.dart';
import 'package:mtrace_app/Models/Expenses.dart';
import 'package:mtrace_app/Models/OfflineExpenses.dart';
import 'package:mtrace_app/Models/User.dart';
import 'package:mtrace_app/Utils/Datas/CategoryRenderData.dart';
import 'package:mtrace_app/Utils/Structure.dart';
import 'package:mtrace_app/Utils/functions/monthToString.dart';
import 'package:provider/provider.dart';

class CategoryScreen extends StatefulWidget {
  static const routeName = "/category";
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Expense> items = [];
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _idController = TextEditingController();
  bool isAdding = false;
  bool isEditing = false;
  bool isDeleting = false;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleController.dispose();
    _amountController.dispose();
    _idController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var categoryId = ModalRoute.of(context)!.settings.arguments;
    final user = Provider.of<User>(context, listen: false);

    var Category = CategoryRenderData.getCategory(categoryId as String);

    setState(() {
      if (user.getOffline) {
        items = Provider.of<OfflineExpenses>(context, listen: false)
            .categoryItems(categoryId);
      } else {
        items = Provider.of<Expenses>(context, listen: false)
            .categoryItems(categoryId);
      }
    });

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(
          color: Color.fromARGB(255, 91, 111, 133), // <-- SEE HERE
        ),
        title: Text(
          Category.name,
          style: const TextStyle(color: Color.fromARGB(255, 91, 111, 133)),
        ),
        iconTheme: const IconThemeData(color: Colors.black, size: 35),
        backgroundColor: const Color.fromRGBO(203, 213, 225, 1),
        actions: [
          if (user.getAuth || user.getOffline)
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          actions: [
                            TextButton(
                                onPressed: (() {
                                  Navigator.of(context).pop();
                                }),
                                child: const Text(
                                  "Ok",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 91, 111, 133)),
                                )),
                          ],
                          title: const Text("Instruction"),
                          content:
                              const Text("You can Long Press to Edit the Item"),
                        );
                      });
                },
                color: const Color.fromARGB(255, 91, 111, 133),
                icon: const Icon(
                  Icons.edit,
                  size: 24,
                )),
          if (user.getAuth || user.getOffline)
            IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (ctx) {
                        return AlertDialog(
                          actions: [
                            TextButton(
                                onPressed: (() {
                                  Navigator.of(context).pop();
                                }),
                                child: const Text(
                                  "Ok",
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 91, 111, 133)),
                                )),
                          ],
                          title: const Text("Instruction"),
                          content: const Text(
                              "You can double tap to delete the Item"),
                        );
                      });
                },
                color: const Color.fromARGB(255, 91, 111, 133),
                icon: const Icon(Icons.delete, size: 24)),
          if ((user.getAuth || user.getOffline) && !isAdding)
            IconButton(
                onPressed: () {
                  setState(() {
                    isAdding = true;
                  });
                },
                color: const Color.fromARGB(255, 91, 111, 133),
                icon: const Icon(Icons.add, size: 28)),
          if ((user.getAuth || user.getOffline) && isAdding)
            IconButton(
                onPressed: () {
                  setState(() {
                    isAdding = false;
                  });
                },
                color: const Color.fromARGB(255, 91, 111, 133),
                icon: const Icon(Icons.dangerous)),
          if (user.getAuth || user.getOffline)
            const SizedBox(
              width: 9,
            ),
          if (user.getAuth)
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(300)),
              margin: const EdgeInsets.only(top: 5, bottom: 5),
              child: CircleAvatar(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(300),
                    child: Image.network(
                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png")),
              ),
            ),
          if (!user.getAuth) const Icon(Icons.login, size: 30),
          const SizedBox(
            width: 10,
          )
        ],
        shadowColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (isAdding)
              Container(
                margin: const EdgeInsets.only(left: 8, right: 8, top: 16),
                padding: const EdgeInsets.only(top: 4),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(203, 213, 225, 1),
                ),
                child: Column(
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                      padding: const EdgeInsets.only(top: 4),
                      child: TextField(
                        autofocus: true,
                        // onTap: addUpwards,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Title",
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        controller: _titleController,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 8, right: 8, top: 1, bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 88,
                            child: TextField(
                              autofocus: true,
                              // onTap: addUpwards,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Amount",
                                fillColor: Colors.white,
                                filled: true,
                              ),
                              controller: _amountController,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            color: const Color.fromARGB(255, 91, 111, 133),
                            child: IconButton(
                                color: Colors.white,
                                onPressed: () {
                                  if (user.getOffline) {
                                    Provider.of<OfflineExpenses>(context,
                                            listen: false)
                                        .addExpenseOffline(
                                            categoryId,
                                            _titleController.text,
                                            double.parse(
                                                _amountController.text))
                                        .then((El) {
                                      setState(() {
                                        items = Provider.of<OfflineExpenses>(
                                                context,
                                                listen: false)
                                            .categoryItems(categoryId);
                                      });

                                      if (El) {
                                        const snackBar = SnackBar(
                                            content: Text("Expense Added"));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      } else {
                                        const snackBar = SnackBar(
                                            content: Text("Expense Not Added"));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    });
                                  } else {
                                    Provider.of<Expenses>(context,
                                            listen: false)
                                        .addExpense(
                                            categoryId,
                                            _titleController.text,
                                            double.parse(
                                                _amountController.text))
                                        .then((El) {
                                      print(El);
                                      if (El) {
                                        const snackBar = SnackBar(
                                            content: Text("Expense Added"));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      } else {
                                        const snackBar = SnackBar(
                                            content: Text("Expense Not Added"));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    });
                                  }
                                },
                                icon: const Icon(
                                  Icons.add,
                                )),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            if (isEditing)
              Container(
                margin: const EdgeInsets.only(left: 8, right: 8, top: 16),
                padding: const EdgeInsets.only(top: 4),
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(203, 213, 225, 1),
                ),
                child: Column(
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                      padding: const EdgeInsets.only(top: 4),
                      child: TextField(
                        autofocus: true,
                        // onTap: addUpwards,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Title",
                          fillColor: Colors.white,
                          filled: true,
                        ),
                        controller: _titleController,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 8, right: 8, top: 1, bottom: 8),
                      child: Row(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 140,
                            child: TextField(
                              autofocus: true,
                              // onTap: addUpwards,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Amount",
                                fillColor: Colors.white,
                                filled: true,
                              ),
                              controller: _amountController,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            color: const Color.fromARGB(255, 91, 111, 133),
                            child: IconButton(
                                color: Colors.white,
                                onPressed: () {
                                  setState(() {
                                    isEditing = false;
                                    _titleController.clear();
                                    _amountController.clear();
                                  });
                                },
                                icon: const Icon(Icons.dangerous)),
                          ),
                          Container(
                            margin: const EdgeInsets.only(left: 6),
                            color: const Color.fromARGB(255, 91, 111, 133),
                            child: IconButton(
                                color: Colors.white,
                                onPressed: () {
                                  if (user.getOffline) {
                                    Provider.of<OfflineExpenses>(context,
                                            listen: false)
                                        .editExpenseOffline(
                                            categoryId,
                                            _idController.text,
                                            _titleController.text,
                                            double.parse(
                                                _amountController.text))
                                        .then((El) {
                                      if (El) {
                                        const snackBar = SnackBar(
                                            content: Text("Expense Edited"));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        setState(() {
                                          _titleController.clear();
                                          _amountController.clear();
                                        });
                                      } else {
                                        const snackBar = SnackBar(
                                            content:
                                                Text("Expense Not Edited"));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    });
                                  } else {
                                    Provider.of<Expenses>(context,
                                            listen: false)
                                        .editExpense(
                                            categoryId,
                                            _idController.text,
                                            _titleController.text,
                                            double.parse(
                                                _amountController.text))
                                        .then((El) {
                                      if (El) {
                                        const snackBar = SnackBar(
                                            content: Text("Expense Edited"));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                        setState(() {
                                          _titleController.clear();
                                          _amountController.clear();
                                        });
                                      } else {
                                        const snackBar = SnackBar(
                                            content:
                                                Text("Expense Not Edited"));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    });
                                  }
                                },
                                icon: const Icon(
                                  Icons.add,
                                )),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: ((ctx) {
                            return ListView(
                              shrinkWrap: true,
                              children: [
                                Container(
                                  color: const Color.fromRGBO(203, 213, 225, 1),
                                  child: const ListTile(
                                    title: Text(
                                      "Sort By",
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 68, 68, 68),
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      Provider.of<Expenses>(context,
                                              listen: false)
                                          .filterItems(
                                              categoryId, Filter.newestFirst);
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: const ListTile(
                                    title: Text("Newest First"),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      Provider.of<Expenses>(context,
                                              listen: false)
                                          .filterItems(
                                              categoryId, Filter.oldestFirst);
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: const ListTile(
                                    title: Text("Oldest First"),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      Provider.of<Expenses>(context,
                                              listen: false)
                                          .filterItems(
                                              categoryId, Filter.lowToHigh);
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: const ListTile(
                                    title: Text("Low To High"),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      Provider.of<Expenses>(context,
                                              listen: false)
                                          .filterItems(
                                              categoryId, Filter.highToLow);
                                    });
                                    Navigator.of(context).pop();
                                  },
                                  child: const ListTile(
                                    title: Text("High To Low"),
                                  ),
                                ),
                              ],
                            );
                          }));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 3),
                      decoration: BoxDecoration(
                          color: const Color.fromRGBO(203, 213, 225, 1),
                          borderRadius: BorderRadius.circular(2)),
                      child: const Text(
                        "Sort",
                        style:
                            TextStyle(color: Color.fromARGB(255, 91, 111, 133)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: ((ctx, i) {
                  // print(items[i].time.day);
                  return GestureDetector(
                    onDoubleTap: () {
                      showDialog(
                          context: context,
                          builder: (ctx) {
                            return AlertDialog(
                              actions: [
                                TextButton(
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                const Color.fromARGB(
                                                    255, 91, 111, 133))),
                                    onPressed: (() {
                                      if (user.getOffline) {
                                        Provider.of<OfflineExpenses>(context,
                                                listen: false)
                                            .deleteExpenseOffline(
                                                categoryId, items[i].id)
                                            .then((El) {
                                          Navigator.of(context).pop();
                                          if (El) {
                                            const snackBar = SnackBar(
                                                content:
                                                    Text("Expense Deleted"));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                            setState(() {
                                              _titleController.clear();
                                              _amountController.clear();
                                            });
                                          } else {
                                            const snackBar = SnackBar(
                                                content: Text(
                                                    "Expense Not Deleted"));

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          }
                                        });
                                      } else {
                                        Provider.of<Expenses>(context,
                                                listen: false)
                                            .deleteExpense(
                                                categoryId, items[i].id)
                                            .then((El) {
                                          Navigator.of(context).pop();
                                          if (El) {
                                            const snackBar = SnackBar(
                                                content:
                                                    Text("Expense Deleted"));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                            setState(() {
                                              _titleController.clear();
                                              _amountController.clear();
                                            });
                                          } else {
                                            const snackBar = SnackBar(
                                                content: Text(
                                                    "Expense Not Deleted"));

                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          }
                                        });
                                      }
                                    }),
                                    child: const Text(
                                      "Yes",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                TextButton(
                                    onPressed: (() {
                                      Navigator.of(context).pop();
                                    }),
                                    child: const Text(
                                      "No",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 91, 111, 133)),
                                    )),
                              ],
                              title: const Text("Confirmation"),
                              content: Text(
                                  "Want to Delete ${items[i].title} of amount ₹${items[i].amount.toString()}"),
                            );
                          });
                    },
                    onLongPress: () {
                      setState(() {
                        isEditing = true;
                        _titleController.text = items[i].title;
                        _amountController.text = items[i].amount.toString();
                        _idController.text = items[i].id;
                      });
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom:
                                  BorderSide(color: Colors.black, width: 1))),
                      child: ListTile(
                        title: Text(items[i].title),
                        subtitle: Row(
                          children: [
                            Text(
                                "${items[i].time.hour.toString()}:${items[i].time.minute.toString()},"),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(items[i].time.day.toString()),
                            const SizedBox(
                              width: 2,
                            ),
                            Text(monthToString(items[i].time.month)),
                            Text(", ${items[i].time.year.toString()}"),
                          ],
                        ),
                        trailing: Text("₹ ${items[i].amount.toString()}"),
                      ),
                    ),
                  );
                })),
          ],
        ),
      ),
    );
  }
}
