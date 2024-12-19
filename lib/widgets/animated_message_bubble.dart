import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../models/chat_message.dart';

class AnimatedMessageBubble extends StatelessWidget {
  final ChatMessage message;

  const AnimatedMessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.only(
          left: message.isUser ? 50.0 : 8.0,
          right: message.isUser ? 8.0 : 50.0,
          top: 8.0,
          bottom: 8.0,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: message.isUser
              ? Theme.of(context).primaryColor
              : Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5.0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: message.isUser
            ? Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : null,
                ),
              )
            : DefaultTextStyle(
                style: TextStyle(
                  color: message.isUser ? Colors.white : null,
                  fontSize: 16.0,
                ),
                child: AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText(
                      message.text,
                      speed: const Duration(milliseconds: 50),
                    ),
                  ],
                  isRepeatingAnimation: false,
                  totalRepeatCount: 1,
                ),
              ),
      ),
    );
  }
}
