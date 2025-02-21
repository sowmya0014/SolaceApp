
import 'package:flutter/material.dart';
import 'login_screen.dart';

class GuidelinesPage extends StatefulWidget {
  const GuidelinesPage({super.key});

  @override
  GuidelinesPageState createState() => GuidelinesPageState();
}

class GuidelinesPageState extends State<GuidelinesPage> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Guidelines')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Expanded(
              child: SingleChildScrollView(
                child: Text(
                  'Community Guidelines:\n\n'
                  '1. Be respectful.\n'
                  '2. No hate speech.\n'
                  '3. Don’t share personal info.\n'
                  '4. Report inappropriate behavior.\n'
                  '5. Use appropriate language.\n',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
            CheckboxListTile(
              value: isChecked,
              onChanged: (value) => setState(() => isChecked = value ?? false),
              title: const Text('I agree to the guidelines'),
            ),
            ElevatedButton(
              onPressed: isChecked
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    }
                  : null,
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}

