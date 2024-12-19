import 'package:flutter/foundation.dart';

@immutable
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final bool isNew;

  const ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
    this.isNew = true,
  });

  ChatMessage.now({
    required String text,
    required bool isUser,
  }) : this(
          text: text,
          isUser: isUser,
          timestamp: DateTime.now(),
        );

  ChatMessage copyWith({
    String? text,
    bool? isUser,
    DateTime? timestamp,
    bool? isNew,
  }) {
    return ChatMessage(
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      isNew: isNew ?? this.isNew,
    );
  }

  Map<String, dynamic> toJson() => {
        'text': text,
        'isUser': isUser,
        'timestamp': timestamp.toIso8601String(),
        'isNew': false, // Always save as not new
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        text: json['text'] as String,
        isUser: json['isUser'] as bool,
        timestamp: DateTime.parse(json['timestamp'] as String),
        isNew: false, // Always load as not new
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatMessage &&
          runtimeType == other.runtimeType &&
          text == other.text &&
          isUser == other.isUser &&
          timestamp == other.timestamp &&
          isNew == other.isNew;

  @override
  int get hashCode => text.hashCode ^ isUser.hashCode ^ timestamp.hashCode ^ isNew.hashCode;
}
