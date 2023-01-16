import 'package:flutter/material.dart';
import 'package:flutter_chat_app/user_list.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Stack(children: [
        Positioned(
          top: 0.0,
          left: 0.0,
          child: Image.asset(
            "assets/login_background.png",
            width: MediaQuery.of(context).size.width,
          ),
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person),
                    fillColor: Colors.white,
                    filled: true,
                    hintText: "Enter your name",
                    hintStyle: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),
                    fillColor: Colors.white,
                    filled: true,
                    // border: InputBorder.none,
                    hintText: "Enter your email",
                    hintStyle: GoogleFonts.poppins(
                      textStyle: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10.0,
                ),
                // TextField(
                //   controller: passwordController,
                //   keyboardType: TextInputType.visiblePassword,
                //   decoration: InputDecoration(
                //     prefixIcon: const Icon(Icons.key),
                //     fillColor: Colors.white,
                //     filled: true,
                //     hintText: "Enter your password",
                //     hintStyle: GoogleFonts.poppins(
                //       textStyle: const TextStyle(
                //         color: Colors.black,
                //       ),
                //     ),
                //   ),
                //   obscureText: true,
                // ),
                const SizedBox(
                  height: 10.0,
                ),
                InkWell(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString('username', nameController.text.toString());
                    prefs.setString('email', emailController.text.toString());
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserList(
                          name: nameController.text.toString(),
                          email: emailController.text.toString(),
                          password: "password",
                        ),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Container(
                      decoration: const BoxDecoration(color: Colors.blue),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Center(
                          child: Text(
                            "SIGN IN",
                            style: GoogleFonts.poppins(
                              textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )),
        ),
      ]),
    );
  }
}
