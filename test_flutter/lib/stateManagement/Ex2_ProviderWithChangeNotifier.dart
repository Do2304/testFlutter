import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Counter with ChangeNotifier {
  int _count = 0;
  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  void reset() {
    _count = 0;
    notifyListeners();
  }
}

class Ex2Statefulwidget extends StatefulWidget {
  const Ex2Statefulwidget({super.key});
  @override
  State<Ex2Statefulwidget> createState() => _Ex2StatefulwidgetState();
}

class _Ex2StatefulwidgetState extends State<Ex2Statefulwidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ex Provider With ChangeNotifier")),
      body: Center(
        child: Column(
          children: [
            Consumer<Counter>(
              builder: (context, value, child) {
                return Text("Số là ${value.count}");
              },
            ),
            Text("Cách 2 Số là: ${context.watch<Counter>().count}"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<Counter>().increment();
              },
              child: Text("tăng"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                context.read<Counter>().reset();
              },
              child: Text("Reset"),
            ),
          ],
        ),
      ),
    );
  }
}
