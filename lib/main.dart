import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_list/data.dart';
import 'package:task_list/editTask.dart';

const taskboxname = 'tasks';
void main() async {
  await Hive.initFlutter(); //inshilazing box
  Hive.registerAdapter(TaskAdapter());
  Hive.registerAdapter(PriorityAdapter());
  //ineroducyion adoptpr
  await Hive.openBox<TaskEntity>(
      taskboxname); //open the box for write information

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: primaryColor,
      systemNavigationBarColor: primaryColor,
      systemStatusBarContrastEnforced: false));
  runApp(const MyApp());
}

//global color
const Color primaryColor = Color(0xff794CFF);
const secondaryTextColor = Color(0xffAFBED0);
const primaryTextColor = Color(0xff1D2830);

const Color primaryVariantColor = Color(0xff5C0AFF);

const normalPriority = Color(0xffF09819);
const lowPriority = Color(0xff3BE1F1);
const highPriority = primaryColor;

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    const Color primaryVariantColor = Color(0xff5C0AFF);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          textTheme: GoogleFonts.inriaSansTextTheme(
            const TextTheme(
                titleLarge: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500)),
          ),
          inputDecorationTheme: const InputDecorationTheme(
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: InputBorder.none,
              prefixIconColor: secondaryTextColor,
              iconColor: secondaryTextColor,
              labelStyle: TextStyle(color: secondaryTextColor)),
          colorScheme: const ColorScheme.light(
              primary: primaryColor,
              inversePrimary: primaryVariantColor,
              onPrimary: Colors.white,
              background: Color(0xffF3F5F8),
              onSurface: primaryTextColor,
              onBackground: primaryTextColor,
              secondary: primaryColor,
              onSecondary: Colors.white)),
      home: HomrScreen(),
    );
  }
}

class HomrScreen extends StatelessWidget {
  HomrScreen({super.key});
  final ValueNotifier<String> sercheKeyNotifyer = ValueNotifier(" ");

  final box = Hive.box<TaskEntity>(taskboxname);
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final TextEditingController _textsercheController = TextEditingController();
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => EditTaskScreen(
                          task: TaskEntity(),
                        )));
              },
              label: Text('Add New Task')),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Container(
                color: primaryColor,
                height: 102,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'To Do List',
                              style: theme.textTheme.titleLarge,
                            ),
                          ),
                          Icon(
                            CupertinoIcons.bell,
                            color: theme.colorScheme.onPrimary,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 9,
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: theme.colorScheme.onPrimary,
                            borderRadius: BorderRadius.circular(19)),
                        height: 40,
                        child: TextField(
                          controller: _textsercheController,
                          onChanged: (value) => sercheKeyNotifyer.value =
                              _textsercheController.text,
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.search),
                              label: Text(
                                'Serch Tasks...',
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: sercheKeyNotifyer,
                  builder: (context, value, child) => ValueListenableBuilder(
                      valueListenable: box.listenable(),
                      builder: (context, box, child) {
                        final ithem;
                        if (_textsercheController.text.isEmpty) {
                          ithem = box.values.toList();
                        } else {
                          ithem = box.values
                              .where((element) => element.name
                                  .contains(_textsercheController.text))
                              .toList();
                        }
                        if (ithem.isNotEmpty) {
                          return ListView.builder(
                              padding:
                                  const EdgeInsets.fromLTRB(14, 14, 14, 100),
                              itemCount: ithem.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'today',
                                              style: theme.textTheme.titleLarge
                                                  ?.copyWith(
                                                      color: primaryTextColor,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w600),
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Container(
                                              height: 3,
                                              width: 70,
                                              decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12)),
                                            )
                                          ],
                                        ),
                                        Container(
                                            width: 118,
                                            height: 35,
                                            decoration: BoxDecoration(
                                                color: Colors.black
                                                    .withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: MaterialButton(
                                                onPressed: () {
                                                  box.clear();
                                                },
                                                child: Row(
                                                  children: [
                                                    Text('Delete All'),
                                                    Icon(
                                                      Icons.delete_outline,
                                                      size: 20,
                                                    ),
                                                  ],
                                                )))
                                      ],
                                    ),
                                  );
                                } else {
                                  final TaskEntity task = ithem[index - 1];
                                  return TaskItheme(task: task);
                                }
                              });
                        } else {
                          return const EmpytyStat();
                        }
                      }),
                ),
              ),
            ],
          ),
        ));
  }
}

class MyCheckIcon extends StatelessWidget {
  final bool value;
  final Function() ontab;
  const MyCheckIcon({super.key, required this.value, required this.ontab});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontab,
      child: Container(
        height: 20,
        width: 20,
        decoration: BoxDecoration(
            color: value ? primaryColor : null,
            borderRadius: BorderRadius.circular(10),
            border: !value ? Border.all(color: secondaryTextColor) : null),
        child: value
            ? Icon(
                Icons.check,
                color: Colors.white,
                size: 20,
              )
            : null,
      ),
    );
  }
}

class TaskItheme extends StatefulWidget {
  const TaskItheme({
    super.key,
    required this.task,
  });

  final TaskEntity task;

  @override
  State<TaskItheme> createState() => _TaskIthemeState();
}

class _TaskIthemeState extends State<TaskItheme> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color poriritycolor;
    switch (widget.task.priority) {
      case Priority.low:
        poriritycolor = lowPriority;
        break;
      case Priority.normal:
        poriritycolor = normalPriority;
        break;

      case Priority.high:
        poriritycolor = highPriority;
        break;
    }
    return InkWell(
      onLongPress: () => widget.task.delete(),
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => EditTaskScreen(task: widget.task))),
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
        margin: const EdgeInsets.fromLTRB(0, 4, 0, 4),
        height: 74,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(blurRadius: 5, color: Colors.black.withOpacity(0.2))
            ]),
        child: Row(
          children: [
            MyCheckIcon(
                value: widget.task.isCompleted,
                ontab: () {
                  setState(() {
                    widget.task.isCompleted = !widget.task
                        .isCompleted; //point: if you want to use the varible in the statefullwidget you shoud use the "widget" before vareble name;z
                  });
                }),
            const SizedBox(
              width: 6,
            ),
            Expanded(
              child: Text(
                  overflow: TextOverflow.visible,
                  widget.task.name,
                  style: TextStyle(
                      fontSize: 20,
                      decoration: widget.task.isCompleted
                          ? TextDecoration.lineThrough
                          : null)),
            ),
            SizedBox(
              width: 8,
            ),
            Container(
              width: 15,
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8)),
                  color: poriritycolor),
            )
          ],
        ),
      ),
    );
  }
}

class EmpytyStat extends StatelessWidget {
  const EmpytyStat({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 75),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/empty_state.svg',
            width: 256,
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Your Task List is empty ',
            style: Theme.of(context)
                .textTheme
                .headline4!
                .apply(color: Colors.black),
          ),
          SizedBox(
            height: 7,
          ),
          Text(
            'you can add a new Task  ',
            style: Theme.of(context).textTheme.headline6!.apply(
                  fontSizeFactor: 0.8,
                  color: Colors.black,
                ),
          ),
        ],
      ),
    );
  }
}
