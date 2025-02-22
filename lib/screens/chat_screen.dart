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

  // Function to detect personal information
  Map<String, double> detectPersonalInfo(String message) {
    Map<String, double> detections = {};
    
    RegExp phoneRegExp = RegExp(r'\b\d{10,}\b');
    RegExp emailRegExp = RegExp(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,7}\b');
    RegExp addressRegExp = RegExp(r'\b\d{1,5}\s\w+(\s\w+)*\b');

    if (phoneRegExp.hasMatch(message)) detections['Phone Number'] = 0.9;
    if (emailRegExp.hasMatch(message)) detections['Email'] = 0.95;
    if (addressRegExp.hasMatch(message)) detections['Address'] = 0.85;

    return detections;
  }

  // Function to generate AI response based on context
  String getContextAwareReply(String message, Map<String, double> detections) {
    message = message.toLowerCase();
    
    if (detections.isNotEmpty) {
      return "Be cautious about sharing personal details online.";
    }
    
    if (message.contains('anxious') || message.contains('anxiety') || message.contains('worried')) {
      return "I understand you're feeling anxious. Would you like to try some breathing exercises?";
    } else if (message.contains('depressed') || message.contains('sad') || message.contains('hopeless')) {
      return "I hear that you're going through a difficult time. Would you like to talk more about it?";
    } else if (message.contains('stress') || message.contains('overwhelmed')) {
      return "It seems like you're under pressure. Let's try to break this down into manageable parts.";
    }
    
    return "I'm here to listen. Would you like to tell me more?";
  }

  // Show consent dialog for potentially sensitive information
  Future<bool> showConsentDialog(Map<String, double> detections) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('⚠️ Sensitive Information Detected'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your message may contain:'),
              const SizedBox(height: 10),
              ...detections.entries.map((entry) => Text(
                '• ${entry.key.toUpperCase()} (${(entry.value * 100).toStringAsFixed(0)}% confidence)',
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
              const SizedBox(height: 15),
              const Text(
                'Sharing personal information is not recommended for your safety. Do you still want to send this message?',
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Edit Message'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Send Anyway'),
            ),
          ],
        );
      },
    ) ?? false;
  }

  // Function to send messages with NLP checking
  Future<void> sendMessage() async {
    String messageText = _messageController.text.trim();

    if (messageText.isNotEmpty && !isBlocked) {
      Map<String, double> detections = detectPersonalInfo(messageText);

      if (detections.isNotEmpty) {
        bool consent = await showConsentDialog(detections);
        if (!consent) return;
      }

      setState(() {
        messages.insert(0, {'sender': widget.username, 'message': messageText});
        _messageController.clear();

        Future.delayed(const Duration(seconds: 1), () {
          if (!isBlocked) {
            setState(() {
              messages.insert(0, {
                'sender': widget.strangerName,
                'message': getContextAwareReply(messageText, detections)
              });
            });
          }
        });
      });
    }
  }

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
