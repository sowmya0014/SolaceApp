
import 'package:flutter/material.dart';
import 'password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  bool isEmail = false;
  bool isValid = false;

  void validateInput(String input) {
    if (isEmail) {
      setState(() {
        isValid = input.contains("@gmail.com");
      });
    } else {
      setState(() {
        isValid = RegExp(r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@\$!%*?&])[A-Za-z\d@\$!%*?&]{8,}$").hasMatch(input);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => isEmail = false),
                    child: const Text("Username"),
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => isEmail = true),
                    child: const Text("Gmail"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _usernameController,
              onChanged: validateInput,
              decoration: InputDecoration(
                labelText: isEmail ? 'Enter Gmail' : 'Enter Username',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isValid
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PasswordScreen(),
                        ),
                      );
                    }
                  : null,
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}
