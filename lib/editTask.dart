import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:task_list/data.dart';
import 'package:task_list/main.dart';

class EditTaskScreen extends StatefulWidget {
  final TaskEntity task;
  const EditTaskScreen({super.key, required this.task});

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
   late final TextEditingController _textcontoroler = TextEditingController(text: widget.task.name);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: theme.colorScheme.surface,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
             widget.task.name = _textcontoroler.text;
            widget.task.priority = widget.task.priority;
            if ( widget.task.isInBox) {
               widget.task.save(); // point: just for uodate box (TAsk for my project) so we must used the (if) for add data in box;
            } else {
              final Box<TaskEntity> box = Hive.box(taskboxname);
              box.add( widget.task);
            }
            Navigator.pop(context);
          },
          label: Text('Save Chenges')),
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        foregroundColor: theme.colorScheme.onSurface,
        title: Text('Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            Flex(
              direction: Axis.horizontal,
              children: [
                Flexible(
                  flex: 1,
                  child: Proirity(
                    ontab: () {
                      setState(() {
                        widget.task.priority = Priority.high;
                      });
                    },
                    lable: "high",
                    color: highPriority,
                    iscomplated: widget.task.priority == Priority.high,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                  flex: 1,
                  child: Proirity(
                    ontab: () {
                      setState(() {
                        widget.task.priority = Priority.normal;
                      });
                    },
                    lable: "normal",
                    color: normalPriority,
                    iscomplated: widget.task.priority == Priority.normal,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Flexible(
                  flex: 1,
                  child: Proirity(
                    ontab: () {
                      setState(() {
                        widget.task.priority = Priority.low;
                      });
                    },
                    lable: "low",
                    color: lowPriority,
                    iscomplated: widget.task.priority == Priority.low,
                  ),
                ),
              ],
            ),
            TextField(
              controller: _textcontoroler,
              decoration: InputDecoration(label: Text("Add a task for today")),
            )
          ],
        ),
      ),
    );
  }
}

class Proirity extends StatelessWidget {
  final String lable;
  final Color color;
  final bool iscomplated;
  final GestureTapCallback ontab;
  const Proirity(
      {super.key,
      required this.lable,
      required this.color,
      required this.iscomplated,
      required this.ontab});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: ontab,
      child: Container(
        height: 40,
        decoration: BoxDecoration(
            color: secondaryTextColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(width: 1, color: theme.colorScheme.onSurface)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(lable),
            MyCheckBoxIcon(
              value: iscomplated,
              color: color,
            )
          ],
        ),
      ),
    );
  }
}

class MyCheckBoxIcon extends StatelessWidget {
  final bool value;
  final Color color;
  const MyCheckBoxIcon({super.key, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 18,
      width: 18,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(9),
      ),
      child: value
          ? Icon(
              Icons.check,
              color: Colors.white,
              size: 18,
            )
          : null,
    );
  }
}
