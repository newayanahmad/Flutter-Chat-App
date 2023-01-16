import 'package:flutter/material.dart';
import 'package:flutter_chat_app/home_page.dart';
import 'package:flutter_chat_app/login_screen.dart';
import 'package:flutter_chat_app/splash_screen.dart';
import 'package:flutter_chat_app/user_list.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

void main() {
  runApp(Phoenix(child: MyApp()));
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String name;
  late String email;
  Future<dynamic> getData() async {
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString('username').toString();
    email = prefs.getString('email').toString();

    return {'name': name, 'email': email};
  }

  @override
  void initState() {
    super.initState();
    // dynamic data = getData().then((value) => value);
    // email = data["email"];
    // name = data["name"];
    // print("email is $email and name is $name");
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    getData();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Meet Me',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: getData()['email'] == null
      //     ? LoginPage()
      //     : UserList(
      //         name: getData()['name'],
      //         email: getData()['email'],
      //         password: "password"),
      home: SplashScreen(),
    );
  }
}
