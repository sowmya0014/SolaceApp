import 'package:flutter/material.dart';
import 'profile_selection_screen.dart';

class PasswordScreen extends StatelessWidget {
  final TextEditingController _passwordController = TextEditingController();

  PasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Enter Password')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (_passwordController.text.length >= 6) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileSelectionScreen(
                        username: '',
                        password: _passwordController.text,
                        interests: const [], // Initialize with empty list
                      ),
                    ),
                  );
                }
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
