import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:intl/intl.dart';
import '../models/chat_message.dart';

class AiChat extends StatefulWidget {
  const AiChat({super.key});

  @override
  State<AiChat> createState() => _AiChatState();
}

class _AiChatState extends State<AiChat> {
  final TextEditingController _controller = TextEditingController();
  List<ChatMessage> _messages = [];
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();
  static const String _storageKey = 'chat_messages';

  static const apiKey = 'AIzaSyBzpeFQqDa77uhslmLLFlCZLzq6HBgOZak';
  late final model = GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: apiKey,
  );
  late final chat = model.startChat(
    history: [
      Content.text(
        'أنت مساعد إسعافات أولية مفيد. قدم نصائح طبية واضحة وموجزة. دائماً ذكّر المستخدمين بطلب المساعدة الطبية المهنية للحالات الخطيرة. اعتمد في ردودك على معلومات طبية موثقة وإرشادات الإسعافات الأولية. تحدث باللغة العربية دائماً.'
      ),
    ],
  );

  bool _isFirstAIReply = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = prefs.getStringList(_storageKey);
    
    if (messagesJson == null || messagesJson.isEmpty) {
      _addWelcomeMessage();
    } else {
      setState(() {
        _messages = messagesJson
            .map((json) => ChatMessage.fromJson(jsonDecode(json)))
            .toList();
      });
    }
  }

  Future<void> _saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final messagesJson = _messages
        .map((msg) => jsonEncode(msg.toJson()))
        .toList();
    await prefs.setStringList(_storageKey, messagesJson);
  }

  void _addWelcomeMessage() {
    final welcomeMessage = ChatMessage(
      text: 'مرحباً! أنا مساعد الإسعافات الأولية الخاص بك. كيف يمكنني مساعدتك اليوم؟',
      isUser: false,
      timestamp: DateTime.now(),
      isNew: true,
    );
    setState(() {
      _messages.add(welcomeMessage);
    });
    _saveMessages();
  }

  Future<void> _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final userMessage = _controller.text;
    _controller.clear();

    final userChatMessage = ChatMessage(
      text: userMessage,
      isUser: true,
      timestamp: DateTime.now(),
      isNew: true,
    );
    
    setState(() {
      _messages.add(userChatMessage);
      _isLoading = true;
    });

    await _saveMessages();
    _scrollToBottom();

    // Simulate AI typing animation for the first reply only
    if (_isFirstAIReply) {
      setState(() {
        _messages.add(ChatMessage(
          text: '...',
          isUser: false,
          timestamp: DateTime.now(),
          isNew: true,
        ));
      });
      await Future.delayed(const Duration(seconds: 2)); // Simulate typing delay
      setState(() {
        _messages.removeWhere((msg) => msg.text == '...'); // Remove typing indicator
        _isFirstAIReply = false; // Set flag to false after first reply
      });
    }

    try {
      final response = await chat.sendMessage(Content.text(userMessage));
      final responseText = response.text ?? 'No response from AI';

      final aiMessage = ChatMessage(
        text: responseText,
        isUser: false,
        timestamp: DateTime.now(),
        isNew: true,
      );
      
      setState(() {
        _messages.add(aiMessage);
      });
      await _saveMessages();
    } catch (e) {
      final errorMessage = ChatMessage(
        text: 'Error: Unable to get response. Please try again later.',
        isUser: false,
        timestamp: DateTime.now(),
        isNew: true,
      );
      
      setState(() {
        _messages.add(errorMessage);
      });
      await _saveMessages();
    } finally {
      setState(() {
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      });
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Chat History'),
        content: const Text('Are you sure you want to delete all chat messages?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _clearChatHistory();
              Navigator.pop(context);
            },
            child: Text(
              'Delete',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _clearChatHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
    setState(() {
      _messages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'AI Chat',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    color: Theme.of(context).colorScheme.primary,
                    onPressed: _showDeleteConfirmation,
                  ),
                ],
              
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: AnimatedMessageBubble(
                              message: _messages[index],
                              isUser: _messages[index].isUser,
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: 'Type your message...',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                              ),
                              onSubmitted: (value) => _sendMessage(),
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.send),
                            onPressed: _sendMessage,
                            color: Theme.of(context).primaryColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class AnimatedMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isUser;

  const AnimatedMessageBubble({
    super.key,
    required this.message,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: isUser ? 64 : 0,
        right: isUser ? 0 : 64,
        bottom: 4,
      ),
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              if (!isUser) ...[
                Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.medical_services_rounded,
                    color: Theme.of(context).colorScheme.primary,
                    size: 18,
                  ),
                ),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: isUser
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(20),
                      topRight: const Radius.circular(20),
                      bottomLeft: Radius.circular(
                        isUser ? 20 : 0,
                      ),
                      bottomRight: Radius.circular(
                        isUser ? 0 : 20,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: isUser ? Colors.white : Colors.black,
                    ),
                  ),
                ),  
              ),
              if (isUser) ...[
                Container(
                  width: 32,
                  height: 32,
                  margin: const EdgeInsets.only(left: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                    size: 18,
                  ),
                ),
              ],
            ],
          ),
          if (message.isNew) ...[
            const SizedBox(height: 4),
            Container(
              height: 8,
              width: 8,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ],
      ),  
    );
  }
}