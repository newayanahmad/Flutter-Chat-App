import 'package:flutter/material.dart';
import 'package:flutter_chat_app/home_page.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'login_screen.dart';

class UserList extends StatefulWidget {
  dynamic name;
  dynamic email;
  dynamic password;
  UserList(
      {Key? key,
      required this.name,
      required this.email,
      required this.password})
      : super(key: key);

  @override
  State<UserList> createState() => _UserListState();
}

class _UserListState extends State<UserList>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late IO.Socket socket;
  late List userList = [];
  void initSocket() {
    print({'name': widget.name, 'email': widget.email});
    socket = IO.io('https://chat-backend-ko3a.onrender.com/', <String, dynamic>{
      'autoConnect': false,
      'transports': ['websocket'],
      'auth': {'name': widget.name, 'email': widget.email}
    });
    // socket = IO.io('https://chat-app.eu-gb.mybluemix.net/', <String, dynamic>{
    //   'autoConnect': false,
    //   'transports': ['websocket'],
    //   'auth': {'name': widget.name, 'email': widget.email}
    // });
    socket.connect();
    socket.onConnect((_) {
      print("connected");
      print(socket.id);
    });
    socket.on('user-list', (users) {
      print(userList);
      if (mounted) {
        setState(() {
          userList = users;
          userList = userList.reversed.toList();
        });
      }
      ;
    });

    print(socket.connected);
  }

  void removeData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    prefs.remove('email');
    socket.emit("close", socket.id);
    // socket.disconnect();
    // socket.destroy();
    socket.onDisconnect((data) {
      print("disconnected");
    });
    socket.close();
    socket.dispose();
    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (context) => LoginPage()),
    // );
    Phoenix.rebirth(context);
    // print(prefs.getString('username'));
    // print(prefs.getString("email"));
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    initSocket();
  }

  @override
  Widget build(BuildContext context) {
    @override
    void dispose() {
      super.dispose();
      socket.dispose();
      widget.email.dispose();
      widget.name.dispose();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${widget.name[0].toUpperCase()}${widget.name.substring(1).toLowerCase()}",
        ),
        actions: [
          Center(
            child: InkWell(
              onTap: removeData,
              child: Text("LogOut"),
            ),
          ),
          SizedBox(
            width: 10.0,
          )
        ],
        bottom: TabBar(controller: _tabController, tabs: [
          Tab(
            text: "Active Users",
          ),
          Tab(
            text: "Past Users",
          ),
        ]),
      ),
      body: TabBarView(controller: _tabController, children: [
        GestureDetector(
          child: ListView.builder(
              itemCount: userList.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    print(userList);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(
                            socket: socket,
                            user: userList[index],
                            currentUser: widget.email,
                            name: widget.name),
                      ),
                    );
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      border: const Border(bottom: BorderSide(width: 0.125)),
                    ),
                    padding: const EdgeInsets.all(20.0),
                    child: Text(userList[index]['name']),
                  ),
                );
              }),
        ),
        const Center(
          child: Text(
            "Past user",
          ),
        ),
      ]),
    );
  }
}
