import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mtrace_app/Models/User.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  static const routeName = "/auth";
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  var isLogin = false;
  var isLoading = false;
  final _nameController = TextEditingController();
  final _emailIdController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailIdController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void changeRoute(String routeName, BuildContext context) {
    Navigator.of(context).pushReplacementNamed(routeName);
  }

  @override
  Widget build(BuildContext context) {
    isLogin = ModalRoute.of(context)!.settings.arguments as bool;

    var login = Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(border: Border.all(color: Colors.purple)),
          child: TextField(
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Email Id",
              fillColor: Colors.white,
              filled: true,
            ),
            controller: _emailIdController,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(border: Border.all(color: Colors.purple)),
          child: TextField(
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Password",
              fillColor: Colors.white,
              filled: true,
            ),
            controller: _passwordController,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        TextButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              var loginRes = await Provider.of<User>(context, listen: false)
                  .login(_emailIdController.text.trim(),
                      _passwordController.text.trim());

              if (loginRes) {
                var snackBar = SnackBar(
                  content: const Text('Logged In'),
                  action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      // Some code to undo the change.
                    },
                  ),
                );
                Provider.of<User>(context, listen: false).setOffline(false);
                Navigator.of(context).pushReplacementNamed("/");
              } else {
                var snackBar = const SnackBar(
                  content: Text('Try Again'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
              setState(() {
                isLoading = false;
              });
            },
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.purple)),
            child: const Text(
              "Login",
              style: TextStyle(color: Colors.white),
            )),
        const SizedBox(
          height: 7,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isLogin = false;
            });
          },
          child: const Text(
            "Create an New Account",
            style: TextStyle(fontSize: 14, color: Colors.purple),
          ),
        ),
      ],
    );

    var register = Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(border: Border.all(color: Colors.purple)),
          child: TextField(
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Name",
              fillColor: Colors.white,
              filled: true,
            ),
            controller: _nameController,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(border: Border.all(color: Colors.purple)),
          child: TextField(
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Email Id",
              fillColor: Colors.white,
              filled: true,
            ),
            controller: _emailIdController,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(border: Border.all(color: Colors.purple)),
          child: TextField(
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Password",
              fillColor: Colors.white,
              filled: true,
            ),
            controller: _confirmPasswordController,
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          padding: const EdgeInsets.only(top: 4),
          decoration: BoxDecoration(border: Border.all(color: Colors.purple)),
          child: TextField(
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: "Confirm Password",
              fillColor: Colors.white,
              filled: true,
            ),
            controller: _passwordController,
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        TextButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              try {
                print(_passwordController.text);

                var Res = await Provider.of<User>(context, listen: false)
                    .register(_nameController.text, _emailIdController.text,
                        _passwordController.text);

                if (Res) {
                  setState(() {
                    isLogin = true;
                  });
                } else {
                  var snackBar = const SnackBar(content: Text("Try Again"));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  // _nameController.clear();
                  // _phoneNumberController.clear();
                  // _emailIdController.clear();
                  // _passwordController.clear();
                  // _confirmCodeController.clear();
                }
                // setState(() {
                //   isConfirmCode = true;
                // });
              } catch (e) {
                print(e);
              }
              setState(() {
                isLoading = false;
              });
            },
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.purple)),
            child: const Text(
              "Sign Up",
              style: TextStyle(color: Colors.white),
            )),
        const SizedBox(
          height: 7,
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              isLogin = true;
            });
          },
          child: const Text(
            "Login Instead",
            style: TextStyle(fontSize: 14, color: Colors.purple),
          ),
        )
      ],
    );

    return Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Container(
                padding: const EdgeInsets.only(
                    top: 20, left: 10, right: 10, bottom: 20),
                width: (MediaQuery.of(context).size.width - 70),
                // height: 500,
                constraints: BoxConstraints(maxHeight: (isLogin ? 270 : 420)),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black38,
                          offset: Offset(0.1, 2),
                          blurRadius: 7,
                          spreadRadius: 0.6,
                          blurStyle: BlurStyle.outer)
                    ]),
                child: Container(
                  child: isLogin ? login : register,
                ),
              ),
            ),
          ),
          if (isLoading)
            Positioned(
              top: 0,
              left: 0,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Container(
                color: const Color.fromRGBO(80, 80, 80, 0.3),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: const Center(child: CircularProgressIndicator()),
              ),
            ),
        ],
      ),
    );
  }
}
