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
  final FocusNode _focusNode = FocusNode();

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
      // print("Created: ${created}");
      setState(() {
        users.add(created);
      });
      _showSnack('Create ${created.name}');
    }
  }

  Future<void> deleteUser(User user) async {
    final url = Uri.parse('http://10.0.2.2:3000/users/${user.id}');
    final result = await http.delete(url);
    if (result.statusCode == 200) {
      setState(() {
        users.removeWhere((u) => u.id == user.id);
        _showSnack('Deleted success');
      });
    }
  }

  Future<void> editUser(User user) async {
    _controllerUser.text = user.name;
    await showDialog(
      context: context,
      builder: (_) {
        Future.delayed(Duration(milliseconds: 100), () {
          _focusNode.requestFocus();
        });
        return AlertDialog(
          title: Text("Edit user"),
          content: TextField(
            controller: _controllerUser,
            focusNode: _focusNode,
            decoration: InputDecoration(
              labelText: "Edit",
              hintText: "chỉnh sửa",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = _controllerUser.text.trim();
                if (name.isNotEmpty) {
                  await updatedUser(user, name);
                  Navigator.pop(context);
                }
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> updatedUser(User user, String name) async {
    final url = Uri.parse('http://10.0.2.2:3000/users/${user.id}');
    final result = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name}),
    );
    if (result.statusCode == 200) {
      setState(() {
        user.name = name;
        _showSnack('Upadted ${user.name}');
      });
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
            return ListTile(
              title: Text(user.name),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => editUser(user),
                    icon: Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () => deleteUser(user),
                    icon: Icon(Icons.delete),
                  ),
                ],
              ),
            );
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
