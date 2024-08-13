import 'package:coco_ai_assistant/COMPONENTS/border_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/button_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/checkbox_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/padding_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/text_view.dart';
import 'package:coco_ai_assistant/FUNCTIONS/array.dart';
import 'package:coco_ai_assistant/FUNCTIONS/colors.dart';
import 'package:coco_ai_assistant/FUNCTIONS/date.dart';
import 'package:coco_ai_assistant/FUNCTIONS/misc.dart';
import 'package:coco_ai_assistant/FUNCTIONS/nav.dart';
import 'package:coco_ai_assistant/MASTER/datamaster.dart';
import 'package:coco_ai_assistant/MODELS/constants.dart';
import 'package:coco_ai_assistant/MODELS/firebase.dart';
import 'package:coco_ai_assistant/MODELS/screen.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/tasks_full_widget.dart';
import 'package:flutter/material.dart';

class TasksWidget extends StatefulWidget {
  DataMaster dm;
  TasksWidget({super.key, required this.dm});

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  void init() async {
    final tempTasks = await widget.dm.getTasks(DateTime.now());
    setState(() {
      widget.dm.setTasks(tempTasks);
    });
  }

  @override
  Widget build(BuildContext context) {
    init();
    return SizedBox(
      width: getWidth(context),
      child: BorderView(
        top: true,
        topColor: Colors.white10,
        bottom: true,
        bottomColor: Colors.white10,
        child: PaddingView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: ButtonView(
                  onPress: () {
                    widget.dm
                        .setToggleTasksWidget(!widget.dm.toggleTasksWidget);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.task_alt,
                            color: Colors.white70,
                            size: 22,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          TextView(
                            text: 'Tasks',
                            color: Colors.white,
                            size: 22,
                            font: 'inconsolata',
                            weight: FontWeight.w600,
                          ),
                        ],
                      ),
                      // if (widget.dm.toggleTasksWidget)
                      //   ButtonView(
                      //       child: const Icon(
                      //         Icons.refresh,
                      //         size: 30,
                      //         color: Colors.white60,
                      //       ),
                      //       onPress: () async {
                      //         final tempTasks =
                      //             await widget.dm.getTasks(DateTime.now());
                      //         setState(() {
                      //           widget.dm.setTasks(tempTasks);
                      //         });
                      //       })

                      ButtonView(
                          child: Icon(
                            widget.dm.toggleTasksWidget
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                            size: 38,
                            color: Colors.white60,
                          ),
                          onPress: () async {
                            setState(() {
                              widget.dm.setToggleTasksWidget(true);
                            });
                          })
                    ],
                  ),
                ),
              ),

              // TASKS
              if (widget.dm.toggleTasksWidget)
                Column(
                  children: [
                    const SizedBox(
                      height: 6,
                    ),
                    ...removeDupes(widget.dm.tasks
                            .map((ting) => ting['category'])
                            .toList())
                        .map((cat) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextView(
                            text: '$cat',
                            size: 22,
                            color: hexToColor("#8EB8ED"),
                            font: 'inconsolata',
                            weight: FontWeight.w600,
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          ...widget.dm.tasks
                              .where((ting) => ting['category'] == cat)
                              .map((task) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    CheckboxView(
                                      onChange: (value) async {
                                        final Map<String, dynamic> thisTask = {
                                          ...task,
                                          'status':
                                              value ? 'COMPLETE' : 'IN PROCESS'
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
                                      width: 8,
                                    ),
                                    SizedBox(
                                      width: getWidth(context) * 0.85,
                                      child: TextView(
                                        text: task['task'],
                                        size: 19,
                                        color: Colors.white,
                                        font: 'inconsolata',
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 35,
                                    ),
                                    TextView(
                                      text: task['priority'],
                                      size: 12,
                                      color: task['priority'] == 'LOW'
                                          ? Colors.yellow
                                          : task['priority'] == 'MEDIUM'
                                              ? Colors.orange
                                              : Colors.red,
                                    ),
                                  ],
                                )
                              ],
                            );
                          }),
                        ],
                      );
                    }),

                    // MORE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ButtonView(
                            child: const TextView(
                              text: 'see more',
                              size: 16,
                              color: Colors.white60,
                              font: 'inconsolata',
                            ),
                            onPress: () {
                              // NAV FULL WIDGET
                              nav_Push(
                                  context,
                                  TasksFullWidget(
                                    dm: widget.dm,
                                  ));
                            })
                      ],
                    )
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
