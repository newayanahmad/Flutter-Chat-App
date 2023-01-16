import 'package:chat_bubbles/bubbles/bubble_special_three.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isSender;
  const MessageBubble({Key? key, required this.message, required this.isSender})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BubbleSpecialThree(
      isSender: isSender,
      text: message,
      color: isSender ? const Color(0xFF1B97F3) : const Color(0xFFE8E8EE),
      tail: false,
      textStyle: isSender
          ? const TextStyle(color: Colors.white, fontSize: 16)
          : const TextStyle(),
      // seen: true,
      delivered: true,
    );
  }
}
