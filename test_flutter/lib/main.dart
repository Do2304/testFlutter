import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './navigation/animateAWidgetAcrossScreens/twoScreens.dart';
import './navigation/navigateWithNamedRoutes/threeScreens.dart';
import './navigation/navigateToANewScreenAndBack/twoScreens.dart';
import './navigation/sendDataToANewScreen/sendDatatoScreenNew.dart';
import './navigation/returnData/returnData.dart';
import './navigation/parseArgNameRoute/partArgNameRoute.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Luli',
      // initialRoute: '/',
      // routes: {
      //   '/': (context) => const FirstScreen(),
      //   '/second': (context) => const SecondScreen(),
      //   '/third': (context) => const thirdScreen(),
      // },
      routes: {
        ExtractArgumentsScreen.routeName: (context) =>
            const ExtractArgumentsScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == PassArgumentsScreen.routeName) {
          final args = settings.arguments as ScreenArguments;

          return MaterialPageRoute(
            builder: (context) {
              return PassArgumentsScreen(
                title: args.title,
                message: args.message,
              );
            },
          );
        }

        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
      home: const HomeScreen(),
      // home: TodosScreen(
      //   todos: List.generate(
      //     20,
      //     (i) => Todo(
      //       'Todo $i',
      //       'A description of what needs to be done for Todo $i',
      //     ),
      //   ),
      // ),
    );
  }
}

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<StatefulWidget> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<dynamic> users = [];

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
      setState(() {
        users = json.decode(response.body);
      });
    } else {
      print('Error fetching users');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test')),
      body: Center(
        child: ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(title: Text(user['name']));
          },
        ),
      ),
      floatingActionButton: ElevatedButton(
        onPressed: fetchUsers,
        child: Text('Refresh'),
      ),
    );
  }
}
