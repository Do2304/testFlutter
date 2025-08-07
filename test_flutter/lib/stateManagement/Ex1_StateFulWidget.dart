import 'package:flutter/material.dart';

class Ex1Statefulwidget extends StatefulWidget {
  const Ex1Statefulwidget({super.key});
  @override
  State<Ex1Statefulwidget> createState() => _Ex1StatefulwidgetState();
}

class _Ex1StatefulwidgetState extends State<Ex1Statefulwidget> {
  int count = 0;
  void handleIncrement() {
    setState(() {
      count++;
    });
  }

  void handleDecrement() {
    setState(() {
      count--;
    });
  }

  void handleReset() {
    setState(() {
      count = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 200),
            Text("Số là: $count", style: TextStyle(fontSize: 20)),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: handleIncrement,
                  icon: Icon(Icons.add),
                  label: Text("Tăng", style: TextStyle(fontSize: 20)),
                ),
                SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: handleDecrement,
                  icon: Icon(Icons.remove),
                  label: Text("Giảm", style: TextStyle(fontSize: 20)),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text("Reset"),
        onPressed: handleReset,
      ),
    );
  }
}
