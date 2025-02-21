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

  // NLP patterns for personal information detection
  final Map<String, RegExp> nlpPatterns = {
    'email': RegExp(
      r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b',
      caseSensitive: false,
    ),
    'phone': RegExp(
      r'\b(\+\d{1,3}[\s-.]?)?\(?\d{3}\)?[\s-.]?\d{3}[\s-.]?\d{4}\b',
    ),
    'location': RegExp(
      r'\b(at|in|near|around|close to)\s+([A-Z][a-z]+(\s+[A-Z][a-z]+)*\s*(,\s*[A-Z]{2})?)\b',
    ),
    'address': RegExp(
      r'\b\d+\s+[A-Za-z\s,]+\b(?:\s*,\s*[A-Za-z\s]+)*\s*\d{5}(?:-\d{4})?\b',
    ),
    'socialMedia': RegExp(
      r'\b(instagram|facebook|twitter|linkedin|snapchat|tiktok)\.com\/[A-Za-z0-9_.]+\b',
      caseSensitive: false,
    ),
  };

  // Extended NLP context patterns
  final Map<String, List<String>> contextPatterns = {
    'location': [
      'meet', 'live', 'staying', 'located', 'visiting', 'near', 'around',
      'street', 'avenue', 'road', 'building', 'plaza', 'mall', 'park'
    ],
    'contact': [
      'call', 'text', 'reach', 'contact', 'phone', 'number', 'cell',
      'mobile', 'telephone', 'whatsapp', 'message me at'
    ],
    'address': [
      'address', 'place', 'apartment', 'house', 'unit', 'floor', 'suite',
      'building', 'block', 'residence', 'postal', 'zip'
    ],
  };

  // ML-based confidence scoring for potential personal information
  double calculateConfidenceScore(String message, String type) {
    double score = 0.0;
    List<String> words = message.toLowerCase().split(' ');
    
    // Context-based scoring
    if (contextPatterns.containsKey(type)) {
      for (String contextWord in contextPatterns[type]!) {
        if (words.contains(contextWord)) {
          score += 0.2;
        }
      }
    }

    // Pattern-based scoring
    if (nlpPatterns[type]!.hasMatch(message)) {
      score += 0.5;
    }

    // Length and complexity scoring
    if (message.length > 20) score += 0.1;
    if (message.contains(RegExp(r'[0-9]'))) score += 0.1;
    if (message.contains(RegExp(r'[.,]'))) score += 0.1;

    return score.clamp(0.0, 1.0);
  }

  // Check for potential personal information using NLP
  Map<String, double> detectPersonalInfo(String message) {
    Map<String, double> detections = {};
    
    nlpPatterns.forEach((type, pattern) {
      double confidence = calculateConfidenceScore(message, type);
      if (confidence > 0.3) {  // Threshold for detection
        detections[type] = confidence;
      }
    });

    return detections;
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
      // Perform NLP analysis
      Map<String, double> detections = detectPersonalInfo(messageText);

      if (detections.isNotEmpty) {
        bool consent = await showConsentDialog(detections);
        if (!consent) return;
      }

      setState(() {
        messages.insert(0, {'sender': widget.username, 'message': messageText});
        _messageController.clear();

        // Simulate chatbot reply with context awareness
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

  // Enhanced bot replies with context awareness
  String getContextAwareReply(String message, Map<String, double> detections) {
    if (detections.isNotEmpty) {
      return "I notice you're sharing some personal information. While I appreciate your trust, please be cautious about sharing sensitive details in chat. How can I help you while keeping your privacy safe?";
    }

    message = message.toLowerCase();
    
    if (message.contains("help") || message.contains("support")) {
      return "I'm here to support you. What's on your mind?";
    } else if (message.contains("sad") || message.contains("depressed")) {
      return "I hear you're going through a difficult time. Would you like to talk about what's troubling you?";
    } else if (message.contains("angry") || message.contains("frustrated")) {
      return "It's okay to feel frustrated. Would you like to share what's causing these feelings?";
    } else if (message.contains("happy") || message.contains("excited")) {
      return "That's wonderful! I'd love to hear more about what's making you feel this way.";
    }

    List<String> empathicResponses = [
      "I understand. Please tell me more.",
      "That's interesting. How does that make you feel?",
      "I'm here to listen. Would you like to elaborate?",
      "Thank you for sharing. What else is on your mind?",
      "I appreciate you opening up. How can I support you?",
    ];
    empathicResponses.shuffle();
    return empathicResponses.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with ${widget.strangerName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.block),
            onPressed: isBlocked ? null : () {
              setState(() {
                isBlocked = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('User blocked successfully')),
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