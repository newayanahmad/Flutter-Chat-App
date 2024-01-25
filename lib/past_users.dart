// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_app/home_page.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class PastUsers extends StatefulWidget {
//   const PastUsers({Key? key}) : super(key: key);

//   @override
//   State<PastUsers> createState() => _PastUsersState();
// }

// class _PastUsersState extends State<PastUsers> {
//   late dynamic userList;
//   late List<String> _filteredKeys;
//   Future<List<String>> _getAllKeysExcept(String keyToExclude) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     Set<String> allKeys = prefs.getKeys();
//     List<String> filteredKeys =
//         allKeys.where((key) => key != keyToExclude).toList();
//     return filteredKeys;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<List<String>>(
//       future: _getAllKeysExcept('keyToExclude'),
//       builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return CircularProgressIndicator();
//         }
//         if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         }
//         _filteredKeys = snapshot.data!;
//         return GestureDetector(
//           child: ListView.builder(
//               itemCount: _filteredKeys.length,
//               itemBuilder: (context, index) {
//                 return InkWell(
//                   onTap: () {
//                     print(_filteredKeys);
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => MyHomePage(
//                             socket: "socket",
//                             user: _filteredKeys[index],
//                             currentUser: "widget.email",
//                             name: {'name': "name"}),
//                       ),
//                     );
//                   },
//                   child: Container(
//                     width: MediaQuery.of(context).size.width,
//                     decoration: BoxDecoration(
//                       color: Colors.grey.shade200,
//                       border: const Border(bottom: BorderSide(width: 0.125)),
//                     ),
//                     padding: const EdgeInsets.all(20.0),
//                     child: Text(_filteredKeys[index]),
//                   ),
//                 );
//               }),
//         );
//       },
//     );
//   }
// }
