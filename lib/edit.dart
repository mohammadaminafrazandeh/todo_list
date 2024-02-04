// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'package:todo_list/main.dart';
import 'package:todo_list/model/data.dart';

class EditTaskScreen extends StatefulWidget {
  const EditTaskScreen({
    Key? key,
    required this.task,
  }) : super(key: key);
  final TaskEntity task;

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.task.name);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: themeData.colorScheme.surface,
        foregroundColor: themeData.colorScheme.onSurface,
        title: const Text('Edit Task'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
          label: const Row(
            children: [
              Text('Save Changes'),
              Icon(
                CupertinoIcons.check_mark,
                size: 16,
              ),
            ],
          ),
          onPressed: () {
            widget.task.name = _controller.text;
            widget.task.priority = widget.task.priority;
            if (widget.task.isInBox) {
              widget.task.save();
            } else {
              final Box<TaskEntity> box = Hive.box(taskBoxName);
              box.add(widget.task);
            }
            Navigator.of(context).pop();
          }),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(
                    flex: 1,
                    child: ProirityCheckBox(
                      onTap: () {
                        setState(() {
                          widget.task.priority = Priority.high;
                        });
                      },
                      label: 'High',
                      color: highPriorityColor,
                      isSelected: widget.task.priority == Priority.high,
                    )),
                const SizedBox(width: 8),
                Flexible(
                    flex: 1,
                    child: ProirityCheckBox(
                      onTap: () {
                        setState(() {
                          widget.task.priority = Priority.medium;
                        });
                      },
                      label: 'Normal',
                      color: normalPriorityColor,
                      isSelected: widget.task.priority == Priority.medium,
                    )),
                const SizedBox(width: 8),
                Flexible(
                    flex: 1,
                    child: ProirityCheckBox(
                      onTap: () {
                        setState(() {
                          widget.task.priority = Priority.low;
                        });
                      },
                      label: 'Low',
                      color: lowPriorityColor,
                      isSelected: widget.task.priority == Priority.low,
                    )),
              ],
            ),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                label: Text(
                  'Add a task for today...',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .apply(fontSizeFactor: 1.2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ProirityCheckBox extends StatelessWidget {
  final String label;
  final Color color;
  final bool isSelected;
  final GestureTapCallback onTap;
  const ProirityCheckBox({
    super.key,
    required this.label,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            width: 2,
            color: secondaryTextColor.withOpacity(0.2),
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Text(label),
            ),
            Positioned(
              right: 8,
              top: 8,
              child: _CheckBoxShape(value: isSelected, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _CheckBoxShape extends StatelessWidget {
  final bool value;
  final Color color;

  const _CheckBoxShape({
    Key? key,
    required this.value,
    required this.color,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: color,
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
