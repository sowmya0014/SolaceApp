import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String username;
  final String strangerName;
  final bool isAI;

  const ChatScreen({
    super.key, 
    required this.username, 
    required this.strangerName,
    this.isAI = false,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, String>> messages = [];
  bool isBlocked = false;

  // Function to check if message contains personal details
  bool containsPersonalInfo(String message) {
    RegExp phoneRegExp = RegExp(r'\b\d{10,}\b');
    RegExp emailRegExp = RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}\b');
    RegExp addressRegExp = RegExp(r'\b\d{1,5}\s\w+(\s\w+)*\b');

    return phoneRegExp.hasMatch(message) || 
           emailRegExp.hasMatch(message) || 
           addressRegExp.hasMatch(message);
  }

  // Function to generate AI response
  String _generateAIResponse(String message) {
    message = message.toLowerCase();
    
    if (message.contains('anxious') || message.contains('anxiety') || message.contains('worried')) {
      return "I understand you're feeling anxious. Would you like to try some breathing exercises?";
    } else if (message.contains('depressed') || message.contains('sad') || message.contains('hopeless')) {
      return "I hear that you're going through a difficult time. Would you like to talk more about it?";
    } else if (message.contains('stress') || message.contains('overwhelmed')) {
      return "It seems like you're under pressure. Let's try to break this down into manageable parts.";
    }
    
    return "I'm here to listen. Would you like to tell me more?";
  }

  // Function to send messages
  void sendMessage() {
    String messageText = _messageController.text.trim();

    if (messageText.isNotEmpty && !isBlocked) {
      if (containsPersonalInfo(messageText)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
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
              messages.insert(0, {'sender': widget.strangerName, 'message': _generateAIResponse(messageText)});
            });
          }
        });
      });
    }
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
                      style: TextStyle(
                        color: isUserMessage ? Colors.white : Colors.black,
                      ),
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
                    onSubmitted: (_) => sendMessage(),
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

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }
}
