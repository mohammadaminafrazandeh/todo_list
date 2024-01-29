import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/model/data.dart';

const taskBoxName = 'tasks';
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<Task>(taskBoxName);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Task>(taskBoxName);
    return Scaffold(
        appBar: AppBar(
          title: const Text('To Do List'),
        ),
        floatingActionButton: FloatingActionButton.extended(
            label: const Text('Add New Task'),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return EditTaskScreen();
                  },
                ),
              );
            }),
        body: ValueListenableBuilder<Box<Task>>(
            valueListenable: box.listenable(),
            builder: (context, Box<Task> box, child) {
              return ListView.builder(
                  itemCount: box.values.length,
                  itemBuilder: (context, index) {
                    final Task task = box.values.toList()[index];
                    return Container(
                      child: Text(task.name),
                    );
                  });
            }));
  }
}

class EditTaskScreen extends StatelessWidget {
  EditTaskScreen({super.key});
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
      ),
      floatingActionButton: FloatingActionButton.extended(
          label: const Text('Save Changes'),
          onPressed: () {
            final task = Task();
            task.name = _controller.text;
            task.priority = Priority.low;
            if (task.isInBox) {
              task.save();
            } else {
              final Box<Task> box = Hive.box(taskBoxName);
              box.add(task);
            }

            Navigator.of(context).pop();
          }),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration:
                const InputDecoration(label: Text('Add a task for today...')),
          ),
        ],
      ),
    );
  }
}
