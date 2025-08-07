import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Todo {
  final String title;
  Todo(this.title);
}

class TodoProvider with ChangeNotifier {
  final List<Todo> _todos = [];
  List<Todo> get todos => _todos;

  void addTodo(String title) {
    _todos.add(Todo(title));
    notifyListeners();
  }

  void removeTodo(int index) {
    _todos.removeAt(index);
    notifyListeners();
  }
}

class TodoScreen extends StatelessWidget {
  TodoScreen({super.key});

  final TextEditingController _todoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final todoProvider = context.watch<TodoProvider>();
    return Scaffold(
      appBar: AppBar(title: Text("Ex3: Provider with ChangeNotifier")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _todoController,
              decoration: InputDecoration(
                labelText: "Công việc cần làm",
                hintText: "Nhập công việc cần làm...",
                suffixIcon: IconButton(
                  onPressed: () {
                    final text = _todoController.text.trim();
                    if (text.isNotEmpty) {
                      context.read<TodoProvider>().addTodo(text);
                      _todoController.clear();
                    }
                  },
                  icon: Icon(Icons.add),
                ),
              ),
            ),
            SizedBox(height: 50),
            Expanded(
              child: ListView.builder(
                itemCount: todoProvider.todos.length,
                itemBuilder: (context, index) {
                  final todo = todoProvider.todos[index];
                  return ListTile(
                    title: Text(todo.title),
                    trailing: IconButton(
                      onPressed: () {
                        context.read<TodoProvider>().removeTodo(index);
                      },
                      icon: Icon(Icons.delete),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
