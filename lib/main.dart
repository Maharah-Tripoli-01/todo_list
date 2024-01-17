import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
          create: (context) => TasksCubit(
                TasksState(
                  tasks: [
                    Task(title: 'First Task', checked: false),
                    Task(title: 'Second Task', checked: false),
                  ],
                ),
              ),
          child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final tasksState = context.watch<TasksCubit>().state;

    final checkedTask =
        tasksState.tasks.where((element) => element.checked).length;
    final percentage = checkedTask / tasksState.tasks.length; // 0 - 1

    return Scaffold(
      appBar: AppBar(
        title: const Text('TodoList'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(value: percentage),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            child: TextField(
              controller: textController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Add Task',
              ),
              onSubmitted: (text) {
                textController.clear();
                context.read<TasksCubit>().addTask(text);
              },
            ),
          ),
          Expanded(
            child: TasksList(onChanged: (index, task) {
              context.read<TasksCubit>().change(index);
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
    final tasksState = context.watch<TasksCubit>().state;

    return ListView.builder(
      itemCount: tasksState.tasks.length,
      itemBuilder: (context, index) {
        final task = tasksState.tasks[index];
        return CheckboxListTile(
          title: Text(task.title),
          value: task.checked,
          onChanged: (value) => onChanged(index, task),
        );
      },
    );
  }
}

class TasksState {
  final List<Task> tasks;

  TasksState({required this.tasks});
}
enum FilterType{
  all,
  done,
  notDone
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

class TasksCubit extends Cubit<TasksState> {
  TasksCubit(super.initialState);

  void addTask(String text) {
    final task = Task(title: text, checked: false);
    final tasksState = TasksState(tasks: state.tasks..add(task));
    emit(tasksState);
  }

  void change(int index) {
    final newTasks = [...state.tasks];

    final task = newTasks[index];

    newTasks[index] = task.copyWith(
      checked: !task.checked,
    );

    emit(TasksState(tasks: newTasks));
  }
}
