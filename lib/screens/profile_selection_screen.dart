// File: lib/screens/profile_selection_screen.dart

import 'package:flutter/material.dart';
import 'chat_screen.dart';

class ProfileSelectionScreen extends StatefulWidget {
  final String username;
  final String password;
  final List<String> interests;

  const ProfileSelectionScreen({
    super.key,
    required this.username,
    required this.password,
    required this.interests,
  });

  @override
  _ProfileSelectionScreenState createState() => _ProfileSelectionScreenState();
}

class _ProfileSelectionScreenState extends State<ProfileSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  String selectedFilter = 'All';

  final List<Map<String, dynamic>> profiles = [
    {
      'name': 'MentalHealthPro',
      'description': 'Licensed therapist, here to support',
      'tags': ['Mental Health', 'Anxiety & Depression', 'Stress Management']
    },
    {
      'name': 'CareerGuide',
      'description': 'Career counselor with 5+ years experience',
      'tags': ['Career & Work', 'Self-Improvement', 'Stress Management']
    },
    {
      'name': 'StudentSupport',
      'description': 'University counselor, specializing in student issues',
      'tags': ['Student Life', 'Stress Management', 'General Support']
    },
    {
      'name': 'AICompanion',
      'description': 'AI-powered chat companion',
      'tags': ['General Support', 'All Topics', 'AI Chat']
    }
  ];

  final List<String> filters = [
    'All',
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

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredProfiles = profiles.where((profile) {
      bool matchesFilter = selectedFilter == 'All' || profile['tags'].contains(selectedFilter);
      bool matchesSearch = profile['name'].toLowerCase().contains(_searchController.text.toLowerCase());
      bool matchesInterests = widget.interests.any((interest) => profile['tags'].contains(interest));
      return matchesFilter && matchesSearch && matchesInterests;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Select Profile')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search profiles',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButton<String>(
              value: selectedFilter,
              isExpanded: true,
              onChanged: (value) => setState(() => selectedFilter = value!),
              items: filters.map((filter) {
                return DropdownMenuItem(value: filter, child: Text(filter));
              }).toList(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProfiles.length,
              itemBuilder: (context, index) {
                final profile = filteredProfiles[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text(profile['name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(profile['description']),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 4,
                          children: (profile['tags'] as List<String>)
                              .map((tag) => Chip(
                                    label: Text(
                                      tag,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    ),
                    isThreeLine: true,
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            username: widget.username,
                            strangerName: profile['name'],
                            isAI: profile['name'] == 'AICompanion',
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}