import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  final String username;
  final String strangerName;

  const ChatScreen({
    super.key, 
    required this.username, 
    required this.strangerName
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  bool _isBlocked = false;

  // Simplified regex patterns for sensitive information
  final Map<String, RegExp> _sensitivePatterns = {
    'Phone Number': RegExp(r'\b\d{10}\b'),
    'Email': RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w{2,}\b'),
    'Address': RegExp(r'\b\d{1,5}\s\w+(\s\w+)*\s(street|avenue|road|boulevard|lane|drive)\b', caseSensitive: false),
    'Social Media': RegExp(r'@\w+'),
    'Website': RegExp(r'https?://\S+'),
  };

  // Check for sensitive information
  List<String> _detectSensitiveInfo(String message) {
    List<String> detectedTypes = [];
    
    for (var entry in _sensitivePatterns.entries) {
      if (entry.value.hasMatch(message.toLowerCase())) {
        detectedTypes.add(entry.key);
      }
    }
    
    return detectedTypes;
  }

  // Show warning dialog for sensitive information
  Future<bool> _showWarningDialog(List<String> sensitiveTypes) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Warning'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your message may contain:'),
            const SizedBox(height: 8),
            ...sensitiveTypes.map((type) => Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text('• $type', style: const TextStyle(fontWeight: FontWeight.bold)),
            )),
            const SizedBox(height: 16),
            const Text(
              'Sharing personal information is not recommended. Do you want to proceed?',
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Edit Message'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Send Anyway'),
          ),
        ],
      ),
    ) ?? false;
  }

  // Get automated response based on message content
  String _getAutomatedResponse(String message) {
    message = message.toLowerCase();
    
    if (message.contains('help') || message.contains('support')) {
      return "I'm here to help. Can you tell me more about what's troubling you?";
    } else if (message.contains('sad') || message.contains('depressed')) {
      return "I hear that you're feeling down. Would you like to talk about what's causing these feelings?";
    } else if (message.contains('anxious') || message.contains('worried')) {
      return "It's normal to feel anxious sometimes. Let's discuss what's making you feel this way.";
    } else if (message.contains('thank')) {
      return "You're welcome! I'm glad I could help.";
    } else {
      return "I understand. Please feel free to share more about your situation.";
    }
  }

  // Send message with safety checks
  Future<void> _sendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty || _isBlocked) return;

    // Check for sensitive information
    final sensitiveTypes = _detectSensitiveInfo(messageText);
    if (sensitiveTypes.isNotEmpty) {
      final shouldSend = await _showWarningDialog(sensitiveTypes);
      if (!shouldSend) return;
    }

    setState(() {
      // Add user message
      _messages.insert(0, ChatMessage(
        text: messageText,
        isUser: true,
        timestamp: DateTime.now(),
      ));

      // Add automated response
      _messages.insert(0, ChatMessage(
        text: _getAutomatedResponse(messageText),
        isUser: false,
        timestamp: DateTime.now(),
      ));

      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.strangerName}'),
        actions: [
          IconButton(
            icon: Icon(_isBlocked ? Icons.block : Icons.block_outlined),
            onPressed: _isBlocked ? null : () {
              setState(() => _isBlocked = true);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User blocked'))
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return MessageBubble(message: message);
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: _isBlocked ? 'Chat blocked' : 'Type a message...',
                        border: const OutlineInputBorder(),
                        enabled: !_isBlocked,
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _isBlocked ? null : _sendMessage,
                    color: Colors.blue,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Message data model
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}

// Message bubble widget
class MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const MessageBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: message.isUser ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.text,
              style: TextStyle(
                color: message.isUser ? Colors.white : Colors.black,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _formatTime(message.timestamp),
              style: TextStyle(
                color: message.isUser ? Colors.white70 : Colors.black54,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}