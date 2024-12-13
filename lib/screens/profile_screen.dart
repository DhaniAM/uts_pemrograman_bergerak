import 'package:flutter/material.dart';
import 'package:uts_pemrograman_bergerak/database/database_helper.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  final int userId;
  final _dbHelper = DatabaseHelper();

  ProfileScreen({required this.userId, Key? key}) : super(key: key);

  Future<Map<String, dynamic>> _fetchUserData() async {
    final data = await _dbHelper.getUserData(userId);
    return data.isNotEmpty ? data.first : {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchUserData(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('User data not found'));
          }
          final userData = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            NetworkImage('https://www.w3schools.com/w3images/avatar2.png'),
                      ),
                      const SizedBox(height: 20),
                      Card(
                        child: ListTile(
                          title: Text('${userData['fullName']}'),
                          subtitle: Text('Username: ${userData['username']}'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                        (route) => false,
                      );
                    },
                    child: const Text('Logout'),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
