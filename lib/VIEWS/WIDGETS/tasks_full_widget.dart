import 'package:coco_ai_assistant/COMPONENTS/alert_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/border_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/button_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/checkbox_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/dropdown_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/loading_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/padding_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/text_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/textfield_view.dart';
import 'package:coco_ai_assistant/FUNCTIONS/array.dart';
import 'package:coco_ai_assistant/FUNCTIONS/colors.dart';
import 'package:coco_ai_assistant/FUNCTIONS/misc.dart';
import 'package:coco_ai_assistant/FUNCTIONS/nav.dart';
import 'package:coco_ai_assistant/MASTER/datamaster.dart';
import 'package:coco_ai_assistant/MODELS/JOBS/coco_jobs.dart';
import 'package:coco_ai_assistant/MODELS/coco.dart';
import 'package:coco_ai_assistant/MODELS/constants.dart';
import 'package:coco_ai_assistant/MODELS/firebase.dart';
import 'package:coco_ai_assistant/MODELS/screen.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/tasks_new_widget.dart';
import 'package:flutter/material.dart';

class TasksFullWidget extends StatefulWidget {
  DataMaster dm;
  TasksFullWidget({super.key, required this.dm});

  @override
  State<TasksFullWidget> createState() => _TasksFullWidgetState();
}

class _TasksFullWidgetState extends State<TasksFullWidget> {
  // VARIABLES
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    setState(() {
      widget.dm.setTasks([]);
    });
    init();
    super.initState();
  }

  void init() async {
    final tempTasks = await widget.dm.getTasks(_selectedDate);
    setState(() {
      widget.dm.setTasks(tempTasks);
    });
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Scaffold(
      backgroundColor: hexToColor(widget.dm.backgroundColor),
      body: Stack(
        children: [
          // MAIN

          // TOP
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              PaddingView(
                  paddingTop: 0,
                  paddingBottom: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ButtonView(
                              child: const Row(
                                children: [
                                  Icon(
                                    Icons.chevron_left,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                  TextView(
                                    text: 'home',
                                    color: Colors.white,
                                    size: 20,
                                    weight: FontWeight.w500,
                                    font: 'inconsolata',
                                  )
                                ],
                              ),
                              onPress: () {
                                nav_Pop(context);
                              }),
                          const SizedBox(
                            height: 6,
                          ),
                          const Row(
                            children: [
                              TextView(
                                text: 'Tasks',
                                size: 24,
                                font: 'inconsolata',
                                weight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              TextView(
                                text: 'widget',
                                color: Colors.white54,
                                size: 16,
                                font: 'inconsolata',
                              )
                            ],
                          )
                        ],
                      ),
                      ButtonView(
                          child: const Icon(
                            Icons.add,
                            size: 36,
                            color: Colors.white70,
                          ),
                          onPress: () {
                            nav_Push(context, TasksNewWidget(dm: widget.dm));
                          })
                    ],
                  )),
              const SizedBox(
                height: 8,
              ), // BODY
              Expanded(
                  child: SizedBox(
                width: double.infinity,
                child: BorderView(
                  top: true,
                  topColor: Colors.white12,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: removeDupes(widget.dm.tasks
                              .map((ting) => ting['category'])
                              .toList())
                          .map((cat) {
                        return PaddingView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextView(
                                text: cat,
                                size: 23,
                                color: Colors.white,
                                font: 'inconsolata',
                                weight: FontWeight.w600,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              ...widget.dm.tasks
                                  .where((ting) => ting['category'] == cat)
                                  .map((task) {
                                return Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        CheckboxView(
                                          onChange: (value) async {
                                            final Map<String, dynamic>
                                                thisTask = {
                                              ...task,
                                              'status': value
                                                  ? 'COMPLETE'
                                                  : 'IN PROCESS'
                                            };

                                            final List<Map<String, dynamic>>
                                                newArr = replaceObjById(
                                              widget.dm.tasks
                                                  .cast<Map<String, dynamic>>(),
                                              task['id'],
                                              thisTask,
                                            );

                                            final bool success =
                                                await firebase_UpdateDocument(
                                              '${appName}_Tasks',
                                              task['id'],
                                              {
                                                'status': value
                                                    ? 'COMPLETE'
                                                    : 'IN PROCESS'
                                              },
                                            );

                                            if (success) {
                                              setState(() {
                                                widget.dm.setTasks(newArr);
                                              });
                                            }
                                          },
                                          defaultValue:
                                              task['status'] == 'COMPLETE',
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        SizedBox(
                                          width: getWidth(context) * 0.85,
                                          child: TextView(
                                            text: task['task'],
                                            size: 20,
                                            color: Colors.white,
                                            font: 'inconsolata',
                                          ),
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const SizedBox(
                                          width: 35,
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              TextView(
                                                text: task['priority'],
                                                size: 12,
                                                color: task['priority'] == 'LOW'
                                                    ? Colors.yellow
                                                    : task['priority'] ==
                                                            'MEDIUM'
                                                        ? Colors.orange
                                                        : Colors.red,
                                              ),
                                              ButtonView(
                                                  child: const TextView(
                                                    text: 'remove',
                                                    size: 18,
                                                    color: Colors.red,
                                                    font: 'inconsolata',
                                                  ),
                                                  onPress: () async {
                                                    final tempTasks =
                                                        await widget.dm
                                                            .removeTask(task);
                                                    widget.dm.setJournalEntries(
                                                        tempTasks);
                                                  })
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              })
                            ],
                          ),
                        );
                      }).toList(), // Convert the iterable to a List<Widget>
                    ),
                  ),
                ),
              ))
            ],
          ),

          // ABSOLUTE
          if (widget.dm.toggleAlert)
            AlertView(
                title: widget.dm.alertTitle,
                message: widget.dm.alertText,
                actions: [
                  ButtonView(
                      child: const TextView(
                        text: 'Close',
                      ),
                      onPress: () {
                        setState(() {
                          widget.dm.setToggleAlert(false);
                        });
                      }),
                  const SizedBox(
                    width: 12,
                  ),
                  ...widget.dm.alertButtons
                ]),
          if (widget.dm.toggleLoading) const LoadingView()
        ],
      ),
    );
  }
}
