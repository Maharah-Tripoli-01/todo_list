import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}
//
// class TaskListTile extends StatefulWidget {
//   const TaskListTile({super.key, required this.title});
//
//   final String title;
//   final bool value;
//
//   @override
//   State<TaskListTile> createState() => _TaskListTileState();
// }
//
// class _TaskListTileState extends State<TaskListTile> {
//   @override
//   Widget build(BuildContext context) {
//     return CheckboxListTile(
//       value: value,
//       title: Text(
//         title,
//       ),
//       onChanged: (_) {
//         setState(() {
//           checked = !checked;
//         });
//       },
//     );
//   }
// }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Task> tasks = [
    Task(title: 'First Task', checked: false),
    Task(title: 'Second Task', checked: false),
  ];

  @override
  Widget build(BuildContext context) {
    final checkedTask = tasks.where((element) => element.checked).length;
    final percentage = checkedTask / tasks.length; // 0 - 1

    return Scaffold(
      appBar: AppBar(
        title: const Text('TodoList'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(value: percentage),
          ...tasks.indexed.map(
            (item) {
              final (index, task) = item;
              return CheckboxListTile(
                title: Text(task.title),
                value: task.checked,
                onChanged: (value) {
                  setState(() {
                    final newTask = task.copyWith(
                      checked: !task.checked,
                    );
                    tasks[index] = newTask;
                  });
                },
              );
            },
          )
        ],
      ),
    );
  }
}

class Task {
  Task({
    required this.title,
    required this.checked,
  });

  final String title;
  final bool checked;

  Task copyWith({
    String? title,
    bool? checked,
  }) {
    return Task(
      title: title ?? this.title,
      checked: checked ?? this.checked,
    );
  }
}
