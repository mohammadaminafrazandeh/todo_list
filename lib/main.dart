import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/model/data.dart';

const taskBoxName = 'tasks';
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<TaskEntity>(taskBoxName);
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: primaryVariantColor));
  runApp(const MyApp());
}

const Color primaryColor = Color(0xff794cff);
const Color primaryVariantColor = Color(0xff5c0aff);
const Color secondaryTextColor = Color(0xffafbed0);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryTextColor = Color(0xff1d2830);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
            TextTheme(titleLarge: TextStyle(fontWeight: FontWeight.bold))),
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: TextStyle(color: secondaryTextColor),
          prefixIconColor: secondaryTextColor,
          border: InputBorder.none,
        ),
        colorScheme: ColorScheme.light(
            primary: primaryColor,
            primaryContainer: primaryVariantColor,
            background: Color(0xfff3f5f8),
            onPrimary: Colors.white,
            onSurface: primaryTextColor,
            onBackground: primaryTextColor,
            secondary: primaryColor,
            onSecondary: Colors.white),
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
    final box = Hive.box<TaskEntity>(taskBoxName);
    final themeData = Theme.of(context);
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
            label: Row(
              children: [
                const Text('Add New Task'),
                const SizedBox(width: 8),
                Icon(CupertinoIcons.add,
                    color: themeData.colorScheme.onPrimary),
              ],
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) {
                    return EditTaskScreen();
                  },
                ),
              );
            }),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                height: 110,
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      themeData.colorScheme.primary,
                      themeData.colorScheme.primaryContainer,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'To Do List',
                            style: themeData.textTheme.titleLarge!
                                .apply(color: themeData.colorScheme.onPrimary),
                          ),
                          Icon(
                            CupertinoIcons.share,
                            color: themeData.colorScheme.onPrimary,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Container(
                        height: 38,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(38 / 2),
                          color: themeData.colorScheme.onPrimary,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: TextField(
                          decoration: InputDecoration(
                            prefixIcon: Icon(CupertinoIcons.search),
                            label: Text(
                              'Search Tasks...',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ValueListenableBuilder<Box<TaskEntity>>(
                    valueListenable: box.listenable(),
                    builder: (context, Box<TaskEntity> box, child) {
                      return ListView.builder(
                          padding: EdgeInsets.fromLTRB(16, 16, 16, 100),
                          itemCount: box.values.length + 1,
                          itemBuilder: (context, index) {
                            if (index == 0) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Today',
                                        style: themeData.textTheme.titleLarge!
                                            .apply(fontSizeFactor: 0.9),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(top: 4),
                                        width: 70,
                                        height: 3,
                                        decoration: BoxDecoration(
                                          color: themeData.colorScheme.primary,
                                          borderRadius:
                                              BorderRadius.circular(1.5),
                                        ),
                                      )
                                    ],
                                  ),
                                  MaterialButton(
                                    elevation: 0,
                                    color: const Color(0xffEAEFF5),
                                    textColor: secondaryTextColor,
                                    onPressed: () {},
                                    child: const Row(
                                      children: [
                                        Text('Delete All'),
                                        SizedBox(
                                          width: 4,
                                        ),
                                        Icon(
                                          CupertinoIcons.delete_solid,
                                          size: 18,
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              );
                            } else {
                              final TaskEntity task =
                                  box.values.toList()[index - 1];
                              return TaskItem(task: task);
                            }
                          });
                    }),
              ),
            ],
          ),
        ));
  }
}

class TaskItem extends StatefulWidget {
  const TaskItem({
    super.key,
    required this.task,
  });

  final TaskEntity task;

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: () {
        setState(() {
          widget.task.isComplete = !widget.task.isComplete;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.only(left: 16, right: 16),
        height: 84,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: themeData.colorScheme.surface,
        ),
        child: Row(
          children: [
            MyCheckBox(value: widget.task.isComplete),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                widget.task.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 24,
                    decoration: widget.task.isComplete
                        ? TextDecoration.lineThrough
                        : null),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyCheckBox extends StatelessWidget {
  final bool value;
  const MyCheckBox({super.key, required this.value});
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: !value
            ? Border.all(
                width: 2,
                color: secondaryTextColor,
              )
            : null,
        color: value ? primaryColor : null,
      ),
      child: value
          ? Icon(
              CupertinoIcons.check_mark,
              color: themeData.colorScheme.onPrimary,
              size: 16,
            )
          : null,
    );
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
            final task = TaskEntity();
            task.name = _controller.text;
            task.priority = Priority.low;
            if (task.isInBox) {
              task.save();
            } else {
              final Box<TaskEntity> box = Hive.box(taskBoxName);
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
