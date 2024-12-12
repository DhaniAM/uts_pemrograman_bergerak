import 'package:flutter/material.dart';
import 'package:uts_pemrograman_bergerak/database_helper.dart';
import 'models/password.dart';

void main() {
  runApp(const PasswordManagerApp());
}

class PasswordManagerApp extends StatelessWidget {
  const PasswordManagerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Password Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PasswordListPage(title: 'Flutter Demo Home Page'),
    );
  }
}

class PasswordListPage extends StatefulWidget {
  const PasswordListPage({super.key, required this.title});

  final String title;

  @override
  State<PasswordListPage> createState() => _PasswordListPageState();
}

class _PasswordListPageState extends State<PasswordListPage> {
  final dbHelper = DatabaseHelper();
  List<Password> passwords = [];
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _refreshPasswordList();
  }

  void _refreshPasswordList() async {
    final data = await dbHelper.getPasswords();
    setState(() {
      passwords = data;
    });
  }

  void _addOrUpdatePassword({Password? password}) async {
    final titleController = TextEditingController(text: password?.title);
    final usernameController = TextEditingController(text: password?.username);
    final passwordController = TextEditingController(text: password?.password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => dialogBuilder(context),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Profile',
          ),
        ],
      ),
      body: IndexedStack(
        index: currentPageIndex,
        children: <Widget>[
          ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: 5,
            itemBuilder: (BuildContext context, int index) {
              return const Card(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text('Hello'),
                ),
              );
            },
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage('https://www.w3schools.com/w3images/avatar2.png'),
                ),
                Card(
                  child: ListTile(
                    title: Text('Your name here'),
                    subtitle: Text('This is a notification'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> dialogBuilder(BuildContext context) {
    String? password;
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Password'),
          actions: [],
        );
      },
    );
  }
}
