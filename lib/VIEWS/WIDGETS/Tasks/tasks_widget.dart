import 'package:coco_ai_assistant/COMPONENTS/border_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/button_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/checkbox_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/future_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/padding_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/roundedcorners_view.dart';
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
import 'package:coco_ai_assistant/VIEWS/WIDGETS/Tasks/tasks_full_widget.dart';
import 'package:flutter/material.dart';

class TasksWidget extends StatefulWidget {
  DataMaster dm;
  TasksWidget({super.key, required this.dm});

  @override
  State<TasksWidget> createState() => _TasksWidgetState();
}

class _TasksWidgetState extends State<TasksWidget> {
  Future<List<dynamic>> _fetchTasks() async {
    return await widget.dm.getTasks(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getWidth(context),
      child: PaddingView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: ButtonView(
                onPress: () {
                  setState(() {
                    widget.dm
                        .setToggleTasksWidget(!widget.dm.toggleTasksWidget);
                  });
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
                  FutureView(
                    future: _fetchTasks(),
                    childBuilder: (data) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var cat in removeDupes(
                                  data.map((ting) => ting['category']).toList())
                              .take(2)
                              .toList())
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextView(
                                  text: cat,
                                  size: 22,
                                  color: hexToColor("#8EB8ED"),
                                  font: 'inconsolata',
                                  weight: FontWeight.w600,
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                for (var task in data
                                    .where((ting) => ting['category'] == cat)
                                    .take(4)
                                    .toList())
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CheckboxView(
                                          defaultValue:
                                              task['status'] == 'IN PROCESS'
                                                  ? false
                                                  : true,
                                          onChange: (value) async {
                                            final newStatus = value
                                                ? 'COMPLETE'
                                                : 'IN PROCESS';
                                            final success =
                                                await firebase_UpdateDocument(
                                                    '${appName}_Tasks',
                                                    task['id'],
                                                    {'status': newStatus});
                                            if (success) {
                                              setState(() {});
                                            }
                                          }),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextView(
                                              text: task['task'],
                                              color: Colors.white,
                                              font: 'inconsolata',
                                              size: 18,
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  )
                              ],
                            )
                        ],
                      );
                    },
                    emptyWidget: const PaddingView(
                      child: Center(
                        child: TextView(
                          text: 'No tasks found.',
                          size: 20,
                          color: Colors.white,
                          font: 'inconsolata',
                        ),
                      ),
                    ),
                  ),

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
                                ), () {
                              setState(() {});
                            });
                          })
                    ],
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
