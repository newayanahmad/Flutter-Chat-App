import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_chat_app/login_screen.dart';
import 'package:flutter_chat_app/user_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void getData() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getString("email").toString() != 'null') {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => UserList(
                  name: prefs.getString('username').toString(),
                  email: prefs.getString('email').toString(),
                  password: "password")));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ));
    }

    print(prefs.getString('username').toString().runtimeType);
    print(prefs.getString("email"));
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          "assets/logo.png",
          width: 100.0,
        ),
      ),
    );
  }
}
