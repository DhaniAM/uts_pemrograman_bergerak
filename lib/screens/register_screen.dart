import 'package:flutter/material.dart';
import 'package:uts_pemrograman_bergerak/database/database_helper.dart';
import 'package:uts_pemrograman_bergerak/models/user.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _usernameController = TextEditingController();
  final _fullnameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _dbHelper = DatabaseHelper();

  void _register() async {
    String username = _usernameController.text.trim();
    String fullname = _fullnameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || fullname.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username, Fullname, and Password cannot be empty')),
      );
      return;
    } else {
      User user = User(username: username, fullName: fullname, password: password);
      final response = await _dbHelper.insertUser(user);
      if (response == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Register failed. Username might be taken')),
        );
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Register success')),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _fullnameController,
              decoration: const InputDecoration(labelText: 'Fullname'),
            ),
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _register,
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
