import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_app/MessageBubble.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.socket, required this.user})
      : super(key: key);

  final IO.Socket socket;
  var user;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final SharedPreferences prefs;
  late IO.Socket socket = widget.socket;
  final messageTextController = TextEditingController();
  late List<Widget> messages = [];
  void initSocket() {
    // socket = IO.io('http://192.168.236.41:3000', <String, dynamic>{
    //   'autoConnect': false,
    //   'transports': ['websocket'],
    //   'auth': {'token': '45454'}
    // });
    // socket = IO.io('https://chat-app.eu-gb.mybluemix.net/', <String, dynamic>{
    //   'autoConnect': false,
    //   'transports': ['websocket'],
    // });
    socket.connect();
    socket.onConnect((_) {
      print("connected");
    });
    // socket.emit('auth', 'ayan');

    socket.on("event", (data) {
      print(data);
      String message = messageTextController.text;
      dynamic position = messageTextController.selection.base.offset;
      setData(data["data"], data["email"], true);
      if (mounted) {
        setState(() {
          messages.add(MessageBubble(message: data["data"], isSender: false));
          messageTextController.text = message;
          messageTextController.selection =
              TextSelection.fromPosition(TextPosition(offset: position));
        });
      }
    });

    socket.on("newUserJoined", (data) {
      messages.add(Container(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10.0)),
          color: Colors.grey.shade300,
        ),
        child: Text("$widget.name joined the chat"),
      ));
    });
    print(socket.connected);
  }

  void getData() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString('username'));
    print(prefs.getString("email"));
  }

  void setData(String message, String sender, bool isSender) async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.getString(sender).toString().runtimeType);
    if (prefs.getString(sender).toString() != 'Null') {
      // List oldmessages = jsonDecode(prefs.getString(sender).toString())
      //     .toList()
      //     .add({"message": message, "isSender": isSender});
      // prefs.setString(sender, jsonEncode(oldmessages));
      // for(var i in prefs.getStringList(sender)!.toList()){
      //   oldmessages.add(MessageBubble(message: message, isSender: isSender))
      // }
    } else {
      prefs.setString(
          sender,
          jsonEncode([
            {"message": message, "isSender": isSender}
          ]));
    }
    print(jsonDecode(prefs.getString(sender).toString()));
  }

  @override
  void initState() {
    super.initState();
    getData();
    initSocket();
  }

  @override
  Widget build(BuildContext context) {
    @override
    void dispose() {
      messageTextController.dispose();
      socket.dispose();

      super.dispose();
    }

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user['name']),
      ),
      body: Stack(children: [
        // Image.asset(
        //   "assets/hi.png",
        // ),
        Container(
          padding: const EdgeInsets.only(bottom: 10.0),
          decoration: const BoxDecoration(
            color: Colors.transparent,
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 8.0),
                Expanded(
                  child: SingleChildScrollView(
                    reverse: true,
                    child: Column(
                      children: messages.isEmpty
                          ? [
                              const Center(
                                child: Text("Message to start conversation..."),
                              )
                            ]
                          : messages,
                    ),
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  margin: const EdgeInsets.only(left: 5.0, right: 5.0),
                  decoration: BoxDecoration(
                      color: Colors.blue.shade400,
                      borderRadius: BorderRadius.circular(20.0)),
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextField(
                          // expands: true,
                          // maxLines: null,
                          cursorColor: Colors.white,
                          style: const TextStyle(color: Colors.white),
                          controller: messageTextController,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              color: Colors.white,
                            ),
                            contentPadding: EdgeInsets.only(left: 10.0),
                            hintText: "Enter message",
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (messageTextController.text.trim() != "") {
                              messages.add(MessageBubble(
                                  message: messageTextController.text,
                                  isSender: true));
                              socket.emit("message", {
                                "msg": messageTextController.text,
                                "toUser": widget.user['email']
                              });
                              // setData(messageTextController.text,
                              //     widget.user["email"], false);
                              messageTextController.text = "";
                            }
                          });
                        },
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                )
              ]),
        ),
      ]),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
