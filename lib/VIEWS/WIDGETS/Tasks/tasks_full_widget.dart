import 'package:coco_ai_assistant/COMPONENTS/checkbox_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/future_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/loading_view.dart';
import 'package:coco_ai_assistant/FUNCTIONS/array.dart';
import 'package:coco_ai_assistant/FUNCTIONS/colors.dart';
import 'package:coco_ai_assistant/MODELS/constants.dart';
import 'package:coco_ai_assistant/MODELS/firebase.dart';
import 'package:flutter/material.dart';
import 'package:coco_ai_assistant/COMPONENTS/alert_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/border_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/button_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/text_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/padding_view.dart';
import 'package:coco_ai_assistant/FUNCTIONS/nav.dart';
import 'package:coco_ai_assistant/MASTER/datamaster.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/Tasks/tasks_edit_widget.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/Tasks/tasks_new_widget.dart';

class TasksFullWidget extends StatefulWidget {
  final DataMaster dm;
  TasksFullWidget({Key? key, required this.dm}) : super(key: key);

  @override
  State<TasksFullWidget> createState() => _TasksFullWidgetState();
}

class _TasksFullWidgetState extends State<TasksFullWidget> {
  DateTime _selectedDate = DateTime.now();

  Future<List<dynamic>> _fetchTasks() async {
    // Fetch tasks from DataMaster
    return await widget.dm.getTasks(_selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexToColor(widget.dm.backgroundColor),
      body: Stack(
        children: [
          // MAIN
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              BorderView(
                bottom: true,
                bottomColor: Colors.white24,
                child: PaddingView(
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
                                Icon(Icons.chevron_left,
                                    color: Colors.white, size: 28),
                                TextView(
                                  text: 'home',
                                  color: Colors.white,
                                  size: 20,
                                  weight: FontWeight.w500,
                                  font: 'inconsolata',
                                ),
                              ],
                            ),
                            onPress: () => nav_Pop(context),
                          ),
                          const SizedBox(height: 6),
                          const Row(
                            children: [
                              TextView(
                                text: 'Tasks',
                                size: 24,
                                font: 'inconsolata',
                                weight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              SizedBox(width: 10),
                              TextView(
                                text: 'widget',
                                color: Colors.white54,
                                size: 16,
                                font: 'inconsolata',
                              ),
                            ],
                          ),
                        ],
                      ),
                      ButtonView(
                        child: const Icon(Icons.add,
                            size: 36, color: Colors.white70),
                        onPress: () {
                          nav_Push(context, TasksNewWidget(dm: widget.dm), () {
                            setState(() {});
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: SizedBox(
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: FutureView(
                        future: _fetchTasks(),
                        childBuilder: (data) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var cat in removeDupes(data
                                  .map((ting) => ting['category'])
                                  .toList() as List<dynamic>))
                                BorderView(
                                  bottom: true,
                                  bottomColor: Colors.white24,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      PaddingView(
                                        paddingTop: 0,
                                        paddingBottom: 0,
                                        child: TextView(
                                          text: cat,
                                          color: hexToColor("#8EB8ED"),
                                          font: 'inconsolata',
                                          size: 22,
                                          weight: FontWeight.w600,
                                        ),
                                      ),
                                      for (var task in data.where(
                                          (ting) => ting['category'] == cat))
                                        PaddingView(
                                          paddingLeft: 10,
                                          paddingRight: 10,
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              CheckboxView(
                                                  onChange: (value) {}),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TextView(
                                                      text: task['task'],
                                                      color: Colors.white,
                                                      size: 18,
                                                      font: 'inconsolata',
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        TextView(
                                                          text: task['priority']
                                                              .toUpperCase(),
                                                          color: task['priority'] ==
                                                                  'LOW'
                                                              ? Colors
                                                                  .lightGreen
                                                              : task['priority'] ==
                                                                      'MEDIUM'
                                                                  ? Colors
                                                                      .yellow
                                                                  : task['priority'] ==
                                                                          'HIGH'
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .grey,
                                                          size: 18,
                                                          font: 'inconsolata',
                                                        ),
                                                        Row(
                                                          children: [
                                                            ButtonView(
                                                              child: TextView(
                                                                text: 'edit',
                                                                color: hexToColor(
                                                                    "#1576D2"),
                                                                font:
                                                                    'inconsolata',
                                                                size: 18,
                                                              ),
                                                              onPress: () {
                                                                nav_Push(
                                                                  context,
                                                                  TasksEditWidget(
                                                                      dm: widget
                                                                          .dm,
                                                                      task:
                                                                          task),
                                                                  () {
                                                                    setState(
                                                                        () {});
                                                                  },
                                                                );
                                                              },
                                                            ),
                                                            const SizedBox(
                                                              width: 15,
                                                            ),
                                                            ButtonView(
                                                              child: TextView(
                                                                text: 'remove',
                                                                color: hexToColor(
                                                                    "#FF1F6E"),
                                                                font:
                                                                    'inconsolata',
                                                                size: 18,
                                                              ),
                                                              onPress:
                                                                  () async {
                                                                await firebase_DeleteDocument(
                                                                    '${appName}_Tasks',
                                                                    task['id']);
                                                                setState(() {});
                                                              },
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
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
                        )),
                  ),
                ),
              ),
            ],
          ),
          // ABSOLUTE
          if (widget.dm.toggleAlert)
            AlertView(
              title: widget.dm.alertTitle,
              message: widget.dm.alertText,
              actions: [
                ButtonView(
                  child: const TextView(text: 'Close'),
                  onPress: () {
                    setState(() {
                      widget.dm.setToggleAlert(false);
                    });
                  },
                ),
                const SizedBox(width: 12),
                ...widget.dm.alertButtons,
              ],
            ),
          if (widget.dm.toggleLoading) const LoadingView(),
        ],
      ),
    );
  }
}
