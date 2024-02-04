import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_list/edit.dart';
import 'package:todo_list/model/data.dart';

const taskBoxName = 'tasks';
void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  await Hive.openBox<TaskEntity>(taskBoxName);
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: primaryVariantColor));
  runApp(const MyApp());
}

const Color primaryColor = Color(0xff794cff);
const Color primaryVariantColor = Color(0xff5c0aff);
const Color secondaryTextColor = Color(0xffafbed0);
const Color normalPriorityColor = Color(0xfff09819);
const Color lowPriorityColor = Color(0xff3be1f1);
const Color highPriorityColor = primaryColor;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const primaryTextColor = Color(0xff1d2830);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo List',
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(const TextTheme(
            titleLarge: TextStyle(fontWeight: FontWeight.bold))),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: secondaryTextColor),
          prefixIconColor: secondaryTextColor,
          border: InputBorder.none,
        ),
        colorScheme: const ColorScheme.light(
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
                    return EditTaskScreen(
                      task: TaskEntity(),
                    );
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
                      const SizedBox(
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
                        child: const TextField(
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
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
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
                                        margin: const EdgeInsets.only(top: 4),
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
  static const double height = 64;
  static const double borderRadius = 8;
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
    final Color priorityColor;
    switch (widget.task.priority) {
      case Priority.low:
        priorityColor = lowPriorityColor;
        break;
      case Priority.medium:
        priorityColor = normalPriorityColor;
        break;
      case Priority.high:
        priorityColor = highPriorityColor;
        break;
    }
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return EditTaskScreen(task: widget.task);
        }));
      },
      child: Container(
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.only(left: 16),
        height: TaskItem.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(TaskItem.borderRadius),
          color: themeData.colorScheme.surface,
        ),
        child: Row(
          children: [
            MyCheckBox(
              value: widget.task.isComplete,
              onTap: () {
                setState(() {
                  widget.task.isComplete = !widget.task.isComplete;
                });
              },
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                widget.task.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    decoration: widget.task.isComplete
                        ? TextDecoration.lineThrough
                        : null),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 5,
              height: TaskItem.height,
              decoration: BoxDecoration(
                  color: priorityColor,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(TaskItem.borderRadius),
                    bottomRight: Radius.circular(TaskItem.borderRadius),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

class MyCheckBox extends StatelessWidget {
  final bool value;
  final GestureTapCallback onTap;
  const MyCheckBox({super.key, required this.value, required this.onTap});
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: Container(
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
      ),
    );
  }
}
