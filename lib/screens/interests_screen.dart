import 'package:flutter/material.dart';
import 'profile_selection_screen.dart';

class InterestsScreen extends StatefulWidget {
  final String username;
  final String password;

  const InterestsScreen({
    super.key,
    required this.username,
    required this.password,
  });

  @override
  _InterestsScreenState createState() => _InterestsScreenState();
}

class _InterestsScreenState extends State<InterestsScreen> {
  final List<String> _categories = [
    'Mental Health',
    'Anxiety & Depression',
    'Career & Work',
    'Relationships',
    'Self-Improvement',
    'Student Life',
    'Family Issues',
    'LGBTQ+ Support',
    'Stress Management',
    'General Support',
  ];

  Set<String> _selectedInterests = {};

  void _toggleInterest(String interest) {
    setState(() {
      if (_selectedInterests.contains(interest)) {
        _selectedInterests.remove(interest);
      } else {
        _selectedInterests.add(interest);
      }
    });
  }

  void _continueToNext() {
    if (_selectedInterests.length >= 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileSelectionScreen(
            username: widget.username,
            password: widget.password,
            interests: _selectedInterests.toList(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Interests')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Choose at least 2 topics you\'d like to discuss',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isSelected = _selectedInterests.contains(category);
                
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    title: Text(category),
                    trailing: Icon(
                      isSelected ? Icons.check_circle : Icons.circle_outlined,
                      color: isSelected ? Colors.blue : null,
                    ),
                    onTap: () => _toggleInterest(category),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _selectedInterests.length >= 2 ? _continueToNext : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              child: Text(
                _selectedInterests.length >= 2
                    ? 'Continue'
                    : 'Select at least 2 topics',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

