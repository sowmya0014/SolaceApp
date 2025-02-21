import 'package:flutter/material.dart';
import 'chat_screen.dart';

class ProfileSelectionScreen extends StatefulWidget {
  final String username;
  final String password;
  final List<String> interests; // Ensuring interests are included

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
    {'name': 'CoderJohn', 'description': 'Loves coding', 'tags': ['coding', 'tech']},
    {'name': 'SciGuy', 'description': 'Science enthusiast', 'tags': ['science']},
    {'name': 'Anonymous123', 'description': 'Here to talk', 'tags': ['mental health', 'support']},
  ];

  final List<String> filters = ['All', 'coding', 'science', 'mental health', 'support'];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredProfiles = profiles.where((profile) {
      bool matchesFilter = selectedFilter == 'All' || profile['tags'].contains(selectedFilter);
      bool matchesSearch = profile['name']!.toLowerCase().contains(_searchController.text.toLowerCase());
      return matchesFilter && matchesSearch;
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
              onChanged: (value) => setState(() {}), // Update list dynamically
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
                    subtitle: Text(profile['description']),
                    trailing: const Icon(Icons.arrow_forward),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            username: widget.username,
                            strangerName: profile['name'],
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
