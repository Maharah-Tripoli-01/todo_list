import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider(
          create: (context) => TasksModel(
                tasks: [
                  Task(title: 'First Task', checked: false),
                  Task(title: 'Second Task', checked: false),
                ],
              ),
          child: const HomePage()),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TasksModel>().tasks;

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
          Expanded(
            child: TasksList(onChanged: (index, task) {
              context.read<TasksModel>().change(index);
            }),
          )
        ],
      ),
    );
  }
}

class TasksList extends StatelessWidget {
  const TasksList({
    super.key,
    required this.onChanged,
  });

  final void Function(int, Task) onChanged;

  @override
  Widget build(BuildContext context) {
    final tasks = context.watch<TasksModel>().tasks;

    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return CheckboxListTile(
          title: Text(task.title),
          value: task.checked,
          onChanged: (value) => onChanged(index, task),
        );
      },
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

class TasksModel extends ChangeNotifier {
  final List<Task> tasks;

  TasksModel({required this.tasks});

  void change(int index) {
    final task = tasks[index];
    tasks[index] = task.copyWith(
      checked: !task.checked,
    );
    notifyListeners();
  }
}
