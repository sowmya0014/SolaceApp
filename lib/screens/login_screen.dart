import 'package:flutter/material.dart';
import 'password_screen.dart';
import 'signup_screen.dart';  // Add this import

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
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Login type selection
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => isEmail = false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !isEmail ? Colors.blue : Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Username"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => isEmail = true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEmail ? Colors.blue : Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Gmail"),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            
            // Login input field
            TextField(
              controller: _usernameController,
              onChanged: validateInput,
              decoration: InputDecoration(
                labelText: isEmail ? 'Enter Gmail' : 'Enter Username',
                prefixIcon: Icon(isEmail ? Icons.email : Icons.person),
                border: const OutlineInputBorder(),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            
            // Login button
            ElevatedButton(
              onPressed: isValid
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PasswordScreen(), // Removed `const`
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 18),
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Divider with "OR" text
            const Row(
              children: [
                Expanded(child: Divider()),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "OR",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(child: Divider()),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Sign Up button
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignupScreen(),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: const BorderSide(color: Colors.blue),
              ),
              child: const Text(
                'Sign Up',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
