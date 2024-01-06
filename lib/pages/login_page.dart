import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/login_logo2.png', // Replace with your image asset path
              height: 300.0,
              width: 250.0,
            ),
            const SizedBox(height: 32.0),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                // Perform login logic here (replace with your actual logic)
                final String username = _usernameController.text;
                final String password = _passwordController.text;

                if (isValidCredentials(username, password)) {
                  // If login is successful, navigate to the main screen
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  // Show an error message (you can customize this part)
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Invalid username or password'),
                    ),
                  );
                }
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  bool isValidCredentials(String username, String password) {
    // Replace this with your actual authentication logic
    return username == 'demo' && password == 'password';
  }
}
