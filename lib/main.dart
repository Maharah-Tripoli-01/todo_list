import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

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

    return TasksInheritedWidget(
      tasks: tasks,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('TodoList'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            LinearProgressIndicator(value: percentage),
            Expanded(
              child: TasksList(onChanged: (index, task) {
                setState(() {
                  final newTask = task.copyWith(
                    checked: !task.checked,
                  );
                  tasks[index] = newTask;
                });
              }),
            )
          ],
        ),
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
    final tasks = context
            .dependOnInheritedWidgetOfExactType<TasksInheritedWidget>()
            ?.tasks ??
        [];

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

class TasksInheritedWidget extends InheritedWidget {
  const TasksInheritedWidget({
    super.key,
    required this.tasks,
    required super.child,
  });

  final List<Task> tasks;

  @override
  bool updateShouldNotify(TasksInheritedWidget oldWidget) {
    return oldWidget.tasks != tasks;
  }
}
