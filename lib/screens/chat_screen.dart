

import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String username;
  final String strangerName;

  const ChatScreen({super.key, required this.username, required this.strangerName});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, String>> messages = [];
  bool isBlocked = false;

  // Function to check if message contains personal details
  bool containsPersonalInfo(String message) {
    // Regular expressions for personal details
    RegExp phoneRegExp = RegExp(r'\b\d{10,}\b'); // Matches numbers with 10+ digits
    RegExp emailRegExp = RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}\b'); // Matches emails
    RegExp addressRegExp = RegExp(r'\b\d{1,5}\s\w+(\s\w+)*\b'); // Basic pattern for addresses

    return phoneRegExp.hasMatch(message) || emailRegExp.hasMatch(message) || addressRegExp.hasMatch(message);
  }

  // Function to send messages
  void sendMessage() {
    String messageText = _messageController.text.trim();

    if (messageText.isNotEmpty && !isBlocked) {
      if (containsPersonalInfo(messageText)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('⚠️ Message contains personal details and cannot be sent!'),
            backgroundColor: Colors.red,
          ),
        );
        return; // Stop message from being sent
      }

      setState(() {
        messages.insert(0, {'sender': widget.username, 'message': messageText});
        _messageController.clear();

        // Simulate chatbot reply
        Future.delayed(const Duration(seconds: 1), () {
          if (!isBlocked) {
            setState(() {
              messages.insert(0, {'sender': widget.strangerName, 'message': getBotReply(messageText)});
            });
          }
        });
      });
    }
  }

  // Function to generate chatbot replies
  String getBotReply(String messageText) {
    messageText = messageText.toLowerCase();

    if (messageText.contains("hi") || messageText.contains("hello")) {
      return "Hello! How are you feeling today?";
    } else if (messageText.contains("sad") || messageText.contains("depressed")) {
      return "I'm here to listen. Want to talk about what's on your mind?";
    } else if (messageText.contains("happy") || messageText.contains("excited")) {
      return "That's great! What made you feel this way?";
    } else if (messageText.contains("help")) {
      return "You are not alone. I'm here to support you. Feel free to share your thoughts.";
    }

    List<String> defaultReplies = [
      "That sounds interesting!",
      "Can you tell me more about it?",
      "I'm listening.",
      "You're doing great!",
      "Would you like to share more?",
    ];
    defaultReplies.shuffle();
    return defaultReplies.first;
  }

  // Function to block user
  void blockUser() {
    setState(() {
      isBlocked = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.strangerName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.block),
            onPressed: isBlocked ? null : blockUser,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUserMessage = message['sender'] == widget.username;
                return Align(
                  alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: isUserMessage ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message['message']!,
                      style: TextStyle(color: isUserMessage ? Colors.white : Colors.black),
                    ),
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
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

