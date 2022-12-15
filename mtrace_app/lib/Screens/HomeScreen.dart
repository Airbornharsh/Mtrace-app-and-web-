import 'package:flutter/material.dart';
import 'package:mtrace_app/Models/Expenses.dart';
import 'package:mtrace_app/Models/User.dart';
import 'package:mtrace_app/Screens/AuthScreen.dart';
import 'package:mtrace_app/Screens/CategoryScreen.dart';
import 'package:mtrace_app/Utils/Datas/CategoryRenderData.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  var start1 = 1;
  var start2 = 1;
  bool checkedOffline = false;
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  bool isAdding = false;
  String activeDropDownMenuId = "food";

  @override
  Widget build(BuildContext context) {
    final expenses = Provider.of<Expenses>(context, listen: false);
    final user = Provider.of<User>(context, listen: false);

    List<Expense> expenseList = [];

    void onStart() {
      expenses.onLoad().then((El) {
        expenseList = El;

        Provider.of<Expenses>(context, listen: false).arrangeItems();
      });
    }

    if (widget.start1 == 1) {
      SharedPreferences.getInstance().then((prefs) {
        // prefs.setString("mtrace_backend_uri", "http://localhost:3000");
        if (prefs.getKeys().contains("mtrace_offline")) {
          setState(() {
            user.setOffline(prefs.getBool("mtrace_offline") as bool);
          });
        }
      });

      widget.start1 = 0;
    }

    if (widget.start2 == 1 && user.getAuth) {
      onStart();
      widget.start2 = 0;
    }

    void setBoolPrefs(String key, bool value) {
      SharedPreferences.getInstance().then((prefs) {
        prefs.setBool(key, value);
      });
    }

    var categoryGrid = GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 60, crossAxisSpacing: 20, mainAxisSpacing: 20),
        itemCount: CategoryRenderData.data.length,
        itemBuilder: ((ctx, i) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(CategoryScreen.routeName,
                  arguments: CategoryRenderData.data[i].id);
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                  color: Color.fromRGBO(203, 213, 225, 1),
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              child: GridTile(
                  child: Image.asset(CategoryRenderData.data[i].imgSrc)),
            ),
          );
        }));

    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Mtrace",
            style: TextStyle(color: Colors.black),
          ),
          iconTheme: const IconThemeData(color: Colors.black, size: 35),
          backgroundColor: const Color.fromRGBO(203, 213, 225, 1),
          actions: [
            if (user.getAuth && !isAdding)
              IconButton(
                  onPressed: () {
                    setState(() {
                      isAdding = true;
                    });
                  },
                  color: const Color.fromARGB(255, 91, 111, 133),
                  icon: const Icon(Icons.add, size: 28)),
            if (user.getAuth && isAdding)
              IconButton(
                  onPressed: () {
                    setState(() {
                      isAdding = false;
                    });
                  },
                  color: const Color.fromARGB(255, 91, 111, 133),
                  icon: const Icon(Icons.dangerous, size: 28)),
            if (user.getAuth)
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
        body: RefreshIndicator(
          onRefresh: () async {
            onStart();
            return;
          },
          child: Container(
            padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
            child: user.getAuth
                ? Column(
                    children: [
                      if (isAdding)
                        Container(
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(203, 213, 225, 1),
                          ),
                          child: Column(
                            children: [
                              Container(
                                decoration:
                                    const BoxDecoration(color: Colors.white),
                                width: MediaQuery.of(context).size.width - 20,
                                margin: const EdgeInsets.only(
                                    left: 8, right: 8, top: 7, bottom: 5),
                                padding: const EdgeInsets.only(left: 10),
                                child: DropdownButton(
                                  value: activeDropDownMenuId,
                                  items: CategoryRenderData.data.map((el) {
                                    return DropdownMenuItem(
                                      value: el.id,
                                      child: Text(el.name),
                                    );
                                  }).toList(),
                                  hint: const Text("Click to Change"),
                                  onChanged: (value) {
                                    setState(() {
                                      activeDropDownMenuId = value as String;
                                    });
                                  },
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 8, right: 8, bottom: 8),
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
                                      width: MediaQuery.of(context).size.width -
                                          88,
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
                                      color: const Color.fromARGB(
                                          255, 91, 111, 133),
                                      child: IconButton(
                                          color: Colors.white,
                                          onPressed: () {
                                            Provider.of<Expenses>(context,
                                                    listen: false)
                                                .addExpense(
                                                    activeDropDownMenuId,
                                                    _titleController.text,
                                                    double.parse(
                                                        _amountController.text))
                                                .then((El) {
                                              print(El);

                                              if (El) {
                                                const snackBar = SnackBar(
                                                    content:
                                                        Text("Expense Added"));

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                                _titleController.clear();
                                                _amountController.clear();
                                              } else {
                                                const snackBar = SnackBar(
                                                    content: Text(
                                                        "Expense Not Added"));

                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              }
                                            });
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
                      categoryGrid
                    ],
                  )
                : !widget.checkedOffline
                    ? Center(
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Where to Store?",
                                style: TextStyle(fontSize: 21),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                      onPressed: () {
                                        Provider.of<User>(context,
                                                listen: false)
                                            .setOffline(false);
                                        setBoolPrefs("mtrace_offline", false);
                                        setState(() {
                                          widget.checkedOffline = true;
                                        });
                                      },
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll<Color>(
                                                  Color.fromARGB(
                                                      255, 124, 139, 158))),
                                      child: const Text(
                                        "Online",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                  const SizedBox(
                                    width: 16,
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        Provider.of<User>(context,
                                                listen: false)
                                            .setOffline(true);
                                        setBoolPrefs("mtrace_offline", true);
                                        setState(() {
                                          widget.checkedOffline = true;
                                        });
                                      },
                                      style: const ButtonStyle(
                                          backgroundColor:
                                              MaterialStatePropertyAll<Color>(
                                                  Color.fromARGB(
                                                      255, 124, 139, 158))),
                                      child: const Text(
                                        "Offline",
                                        style: TextStyle(color: Colors.white),
                                      ))
                                ],
                              )
                            ],
                          ),
                        ),
                      )
                    : !user.getOffline
                        ? Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              AuthScreen.routeName,
                                              arguments: true);
                                    },
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll<Color>(
                                                Color.fromARGB(
                                                    255, 124, 139, 158))),
                                    child: const Text(
                                      "Login",
                                      style: TextStyle(color: Colors.white),
                                    )),
                                const SizedBox(
                                  width: 20,
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushReplacementNamed(
                                              AuthScreen.routeName,
                                              arguments: false);
                                    },
                                    style: const ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll<Color>(
                                                Color.fromARGB(
                                                    255, 124, 139, 158))),
                                    child: const Text(
                                      "Register",
                                      style: TextStyle(color: Colors.white),
                                    )),
                              ],
                            ),
                          )
                        : categoryGrid,
          ),
        ));
  }
}
