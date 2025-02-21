// File: lib/models/mental_health_chatbot.dart

class MentalHealthChatbot {
  final Map<String, List<String>> responses = {
    'anxiety': [
      'It sounds like youre feeling anxious. Would you like to try some breathing exercises?',
      'I understand anxiety can be overwhelming. What usually helps you feel more grounded?',
      'Lets take this one step at a time. Can you tell me more about whats causing your anxiety?'
    ],
    'depression': [
      'I hear that youre going through a difficult time. Would you like to talk more about it?',
      'Remember that its okay to not be okay. Have you considered speaking with a professional counselor?',
      'Your feelings are valid. What kind of support would be most helpful right now?'
    ],
    'stress': [
      'It seems like youre under a lot of pressure. Lets try to break this down into manageable parts.',
      'Taking care of yourself is important. What self-care activities do you enjoy?',
      'Would you like to explore some stress management techniques together?'
    ],
    'default': [
      'I am here to listen. Would you like to tell me more?',
      'Thank you for sharing that with me. How can I best support you right now?',
      'I understand this might be difficult to talk about. Take your time.',
      'Your feelings are important. Would you like to explore this further?'
    ]
  };

  String generateResponse(String message) {
    message = message.toLowerCase();
    
    if (message.contains('anxious') || message.contains('anxiety') || message.contains('worried')) {
      return _getRandomResponse('anxiety');
    } else if (message.contains('depressed') || message.contains('sad') || message.contains('hopeless')) {
      return _getRandomResponse('depression');
    } else if (message.contains('stress') || message.contains('overwhelmed') || message.contains('pressure')) {
      return _getRandomResponse('stress');
    }
    
    return _getRandomResponse('default');
  }

  String _getRandomResponse(String category) {
    final responseList = responses[category] ?? responses['default']!;
    return responseList[DateTime.now().millisecondsSinceEpoch % responseList.length];
  }
}