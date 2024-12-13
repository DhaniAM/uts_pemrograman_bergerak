import 'package:flutter/material.dart';
import '../models/password.dart';
import '../database/database_helper.dart';

class PasswordScreen extends StatefulWidget {
  final int userId;
  PasswordScreen({required this.userId});

  @override
  _PasswordScreenState createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  List<Password> _passwords = [];
  int currentPageIndex = 0;
  final _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadPasswords();
  }

  Future<void> _loadPasswords() async {
    final List<Map<String, dynamic>> results = await _dbHelper.loadPassword(widget.userId);
    setState(() {
      _passwords = results.map((item) => Password.fromMap(item)).toList();
    });
  }

  void _addOrUpdatePassword({Password? password}) async {
    final titleController = TextEditingController(text: password?.title);
    final usernameController = TextEditingController(text: password?.username);
    final passwordController = TextEditingController(text: password?.password);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(password == null ? 'Add Password' : 'Update Password'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (titleController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Title cannot be empty')));
                  return;
                }
                if (usernameController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Username cannot be empty')));
                  return;
                }
                if (passwordController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('Password cannot be empty')));
                  return;
                }
                if (password == null) {
                  // add new password
                  final newPassword = Password(
                    userId: widget.userId,
                    title: titleController.text,
                    username: usernameController.text,
                    password: passwordController.text,
                  );
                  await _dbHelper.insertPassword(newPassword);
                } else {
                  // edit password
                  final updatedPassword = Password(
                    id: password.id,
                    userId: password.userId,
                    title: titleController.text,
                    username: usernameController.text,
                    password: passwordController.text,
                  );
                  await _dbHelper.updatePassword(updatedPassword);
                }
                Navigator.of(context).pop();
                _loadPasswords();
              },
              child: Text(password == null ? "Add" : "Save"),
            ),
          ],
        );
      },
    );
  }

  void _deletePassword(int id) async {
    _dbHelper.deletePassword(id);
    _loadPasswords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Passwords'),
      ),
      body: _passwords.isEmpty
          ? const Center(child: Text('No passwords found'))
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _passwords.length,
              itemBuilder: (BuildContext context, int index) {
                final password = _passwords[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.deepPurpleAccent),
                    ),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      tileColor: Colors.deepPurpleAccent[50],
                      title: Text(password.title),
                      subtitle: Text(password.username),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            onPressed: () => _addOrUpdatePassword(password: password),
                            icon: Icon(
                              Icons.edit,
                              color: Colors.cyan[600],
                            ),
                          ),
                          IconButton(
                            onPressed: () => _deletePassword(password.id!),
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrUpdatePassword(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
