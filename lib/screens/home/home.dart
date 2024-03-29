import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:todo_list/data/model/data.dart';
import 'package:todo_list/main.dart';
import 'package:todo_list/repo/repository.dart';
import 'package:todo_list/screens/edit/cubit/edit_task_cubit.dart';
import 'package:todo_list/screens/edit/edit.dart';
import 'package:todo_list/screens/home/bloc/task_list_bloc.dart';
import 'package:todo_list/widget/widgets.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
                    return BlocProvider<EditTaskCubit>(
                        create: (context) => EditTaskCubit(
                            context.read<Repository<TaskEntity>>(),
                            TaskEntity()),
                        child: const EditTaskScreen());
                  },
                ),
              );
            }),
        body: BlocProvider<TaskListBloc>(
          create: (context) =>
              TaskListBloc(context.read<Repository<TaskEntity>>()),
          child: SafeArea(
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
                              style: themeData.textTheme.titleLarge!.apply(
                                  color: themeData.colorScheme.onPrimary),
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
                          child: TextField(
                            controller: controller,
                            onChanged: (value) {
                              context
                                  .read<TaskListBloc>()
                                  .add(TaskListSearch(value));
                            },
                            decoration: const InputDecoration(
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
                Expanded(child: Consumer<Repository<TaskEntity>>(
                    builder: (context, repository, child) {
                  context.read<TaskListBloc>().add(TaskListStarted());
                  return BlocBuilder<TaskListBloc, TaskListState>(
                    builder: (context, state) {
                      if (state is TaskListSuccess) {
                        return TaskList(
                            items: state.items, themeData: themeData);
                      } else if (state is TaskListEmpty) {
                        return const EmptyState();
                      } else if (state is TaskListLoading ||
                          state is TaskListInitial) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is TaskListError) {
                        return Center(
                          child: Text(state.errorMessage),
                        );
                      } else {
                        throw Exception('state is not valid..');
                      }
                    },
                  );
                }))
              ],
            ),
          ),
        ));
  }
}

class TaskList extends StatelessWidget {
  const TaskList({
    super.key,
    required this.items,
    required this.themeData,
  });

  final List<TaskEntity> items;
  final ThemeData themeData;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        borderRadius: BorderRadius.circular(1.5),
                      ),
                    )
                  ],
                ),
                MaterialButton(
                  elevation: 0,
                  color: const Color(0xffEAEFF5),
                  textColor: secondaryTextColor,
                  onPressed: () {
                    final taskRepository = Provider.of<Repository<TaskEntity>>(
                        context,
                        listen: false);
                    taskRepository.deleteAll();
                  },
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
            final TaskEntity task = items[index - 1];
            return TaskItem(task: task);
          }
        });
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
      onLongPress: () {
        showDialog(
            context: context,
            builder: (context) {
              return AlertDialog.adaptive(
                  title: const Text('Delete Task'),
                  content:
                      const Text('Are you sure you want to delete this task?'),
                  actions: [
                    TextButton(
                      onPressed: Navigator.of(context).pop,
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        widget.task.delete();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Delete'),
                    )
                  ]);
            });
      },
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return BlocProvider<EditTaskCubit>(
              create: (context) => EditTaskCubit(
                  context.read<Repository<TaskEntity>>(), widget.task),
              child: const EditTaskScreen());
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
