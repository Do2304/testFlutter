import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class User {
  final String id;
  String name;
  User({required this.id, required this.name});
  factory User.fromJson(Map<String, dynamic> j) =>
      User(id: j['id'], name: j['name']);

  @override
  String toString() {
    return 'User(id: $id, name: $name)';
  }
}

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<StatefulWidget> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<User> users = [];
  final TextEditingController _controllerUser = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final url = Uri.parse('http://10.0.2.2:3000/users');
    final response = await http.get(url);

    print('-------: ${response.statusCode}');
    print('-------: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> list = jsonDecode(response.body);
      setState(() {
        users = list.map((e) => User.fromJson(e)).toList();
      });
    } else {
      print('Error fetching users');
    }
  }

  Future<void> createUser(String name) async {
    final url = Uri.parse('http://10.0.2.2:3000/users');
    final result = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name}),
    );
    if (result.statusCode == 200) {
      final data = jsonDecode(result.body);
      final created = User.fromJson(data['user']);
      print("Created: ${created}");
      setState(() {
        users.add(created);
      });
      _showSnack('Create ${created.name}');
    }
  }

  void _showSnack(String s) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
  }

  Future<void> handleCreateUser() async {
    _controllerUser.clear();
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Create User"),
        content: TextField(
          controller: _controllerUser,
          decoration: InputDecoration(
            labelText: "Create User",
            hintText: "Nhập",
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              final name = _controllerUser.text.trim();
              if (name.isNotEmpty) {
                createUser(name);
                Navigator.pop(context);
              }
            },
            child: Text("Create"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD'),
        actions: [
          IconButton(onPressed: handleCreateUser, icon: Icon(Icons.add)),
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(title: Text(user.name));
          },
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: fetchUsers,
        child: Text('Fetch User'),
      ),
    );
  }
}
