import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mtrace_app/Models/Expenses.dart';
import 'package:mtrace_app/Models/OfflineExpenses.dart';
import 'package:mtrace_app/Models/User.dart';
import 'package:mtrace_app/Screens/AuthScreen.dart';
import 'package:mtrace_app/Screens/CategoryScreen.dart';
import 'package:mtrace_app/Screens/HomeScreen.dart';
import 'package:mtrace_app/Screens/ProfileScreen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  await Hive.initFlutter();

  await Hive.openBox("mtraceExpenseBox");

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SharedPreferences.getInstance().then((prefs) {
      // prefs.setString("mtrace_backend_uri", "http://localhost:3000");
      prefs.setString("mtrace_backend_uri", "http://10.0.2.2:3000");
    });

    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: User()),
        ChangeNotifierProvider.value(value: Expenses()),
        ChangeNotifierProvider.value(value: OfflineExpenses()),
      ],
      child: MaterialApp(
        title: 'MTrace',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color.fromRGBO(203, 213, 225, 1),
          ),
        ),
        // home: const HomeScreen(),
        home: HomeScreen(),
        routes: {
          AuthScreen.routeName: (ctx) => const AuthScreen(),
          ProfileScreen.routeName: (ctx) => const ProfileScreen(),
          CategoryScreen.routeName: (ctx) => const CategoryScreen(),
        },
      ),
    );
  }
}
