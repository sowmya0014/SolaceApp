
import 'package:flutter/material.dart';
import 'profile_selection_screen.dart';

class PasswordScreen extends StatelessWidget {
  const PasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _passwordController = TextEditingController();

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Enter Your Password', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(hintText: 'Password'),
              ),
              const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  if (_passwordController.text.length >= 6) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProfileSelectionScreen(username: '', password: _passwordController.text),
                      ),
                    );
                  }
                },
                child: const Text('Next'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}