import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserData {
  final String name;
  final String emailId;
  final String income;
  final String createdAt;

  UserData(
      {required this.name,
      required this.emailId,
      required this.income,
      required this.createdAt});
}

class User with ChangeNotifier {
  late UserData _user;
  bool _isAuth = false;
  bool _isOffline = false;
  late String _token;

  UserData get getUserData {
    return _user;
  }

  bool get getAuth {
    return _isAuth;
  }

  bool get getOffline {
    return _isOffline;
  }

  String get getToken {
    return _token;
  }

  void setAuth(bool data) {
    _isAuth = data;
  }

  void setOffline(bool data) {
    print(data); 
    _isOffline = data;
  }

  Future<bool> register(String name, String emailId, String password) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("mtrace_backend_uri") as String;

    try {
      var Res = await client.post(Uri.parse("$domainUri/api/register"),
          body: json
              .encode({"name": name, "emailId": emailId, "password": password}),
          headers: {"Content-Type": "application/json"});

      if (Res.statusCode != 200) {
        return false;
      }

      // var parsedBody = json.decode(Res.body);

      // _otpAccessToken = parsedBody["accessToken"];
      return true;
    } catch (e) {
      print(e);
      return false;
    } finally {
      client.close();
      notifyListeners();
    }
  }

  Future<bool> login(String emailId, String password) async {
    var client = Client();
    final prefs = await SharedPreferences.getInstance();
    String domainUri = prefs.get("mtrace_backend_uri") as String;

    try {
      var tokenRes = await client.post(Uri.parse("$domainUri/api/login"),
          body: json.encode(
              {"emailId": "airbornharsh69@gmail.com", "password": "password"}),
          // body: json.encode({"emailId": emailId, "password": password}),
          headers: {"Content-Type": "application/json"});

      if (tokenRes.statusCode != 200) {
        throw tokenRes.body;
      }

      var parsedBody = json.decode(tokenRes.body);

      prefs.setString("mtrace_accessToken", parsedBody["accessToken"]);
      _token = parsedBody["accessToken"];
      _isAuth = true;

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
