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
  late List<Map<String, dynamic>> messagesFromPrefs = [];
  late String _email;

  void initSocket() async {
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

    // retrieve messages from shared preferences
    prefs = await SharedPreferences.getInstance();
    _email = widget.user["email"];
    var _messages = prefs.getString(_email);
    if (_messages != null) {
      messagesFromPrefs = List<Map<String, dynamic>>.from(
          jsonDecode(_messages) as List<dynamic>);
      for (var message in messagesFromPrefs) {
        setState(() {
          if (mounted) {
            messages.add(MessageBubble(
                message: message["message"], isSender: message["isSender"]));
          }
        });
      }
    }

    socket.on("event", (data) {
      String message = messageTextController.text;
      dynamic position = messageTextController.selection.base.offset;
      setData(data["data"], data["email"], false);
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

  void setData(String message, String sender, bool isSender) async {
    messagesFromPrefs.add({"message": message, "isSender": isSender});
    prefs.setString(_email, jsonEncode(messagesFromPrefs));
  }

  @override
  void dispose() {
    super.dispose();
// close the socket connection when the widget is disposed
    socket.disconnect();
  }

  @override
  void initState() {
    super.initState();
    initSocket();
  }

  @override
  Widget build(BuildContext context) {
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
                              setData(messageTextController.text,
                                  widget.user["email"], true);
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
