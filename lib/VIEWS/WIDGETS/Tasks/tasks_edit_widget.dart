import 'package:coco_ai_assistant/COMPONENTS/alert_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/border_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/button_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/dropdown_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/loading_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/padding_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/text_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/textfield_view.dart';
import 'package:coco_ai_assistant/FUNCTIONS/array.dart';
import 'package:coco_ai_assistant/FUNCTIONS/colors.dart';
import 'package:coco_ai_assistant/FUNCTIONS/date.dart';
import 'package:coco_ai_assistant/FUNCTIONS/nav.dart';
import 'package:coco_ai_assistant/MASTER/datamaster.dart';
import 'package:coco_ai_assistant/MODELS/JOBS/coco_jobs.dart';
import 'package:coco_ai_assistant/MODELS/coco.dart';
import 'package:coco_ai_assistant/MODELS/screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TasksEditWidget extends StatefulWidget {
  DataMaster dm;
  Map<String, dynamic> task;
  TasksEditWidget({super.key, required this.dm, required this.task});

  @override
  State<TasksEditWidget> createState() => _TasksEditWidgetState();
}

class _TasksEditWidgetState extends State<TasksEditWidget> {
  TextEditingController _taskController = TextEditingController();
  @override
  void initState() {
    super.initState();
    setState(() {
      //
      widget.dm.setTasks([]);
      widget.dm.init_taskTextController();
      widget.dm.init_categoryTextController();
      widget.dm.init_dateTextController();
      widget.dm.taskTextController.text = widget.task['task'];
      widget.dm.categoryTextController.text = widget.task['category'];
      widget.dm.setPriority(widget.task['priority']);
      final date = DateTime.parse(widget.task['date']);
      widget.dm.dateTextController.text = formatDate(date);
    });
  }

  void onUpdateTask() async {
    final _task = widget.dm.taskTextController.text;
    final _category = widget.dm.categoryTextController.text;
    final _date = widget.dm.dateTextController.text;
    final _priority = widget.dm.priority;

    if (_task.isEmpty ||
        _category.isEmpty ||
        _date.isEmpty ||
        _priority.isEmpty) {
      setState(() {
        widget.dm.setAlertTitle('Missing Info');
        widget.dm.setAlertText('Please provide all parts to create this task.');
        widget.dm.setToggleAlert(true);
      });
      return;
    }

    setState(() {
      widget.dm.setToggleLoading(true);
    });
    final chat = await coco_StartCustomChat(
        'UserId: ${widget.dm.userId}. You are a task manager that updates tasks.',
        declarationList);

    final response = await coco_SendChat(
        chat,
        'Update a task for me: Id: ${widget.task['id']} Task: $_task. Category: $_category. Date: $_date. Priority: $_priority.',
        functionMap);

    setState(() {
      widget.dm.setToggleLoading(false);
    });

    nav_Pop(context);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _taskController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexToColor("#222028"),
      body: Stack(
        children: [
          Container(
            color: hexToColor("#12161D"),
            height: getHeight(context),
            child: SingleChildScrollView(
              child: PaddingView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TextView(
                          text: 'edit task',
                          size: 24,
                          color: Colors.white,
                          font: 'inconsolata',
                          weight: FontWeight.w500,
                        ),
                        ButtonView(
                            child: const Row(
                              children: [
                                TextView(
                                  text: "close",
                                  size: 20,
                                  font: 'inconsolata',
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Icon(
                                  Icons.close,
                                  size: 24,
                                  color: Colors.white,
                                )
                              ],
                            ),
                            onPress: () {
                              nav_Pop(context);
                            })
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // TASK
                        const TextView(
                          text: 'task',
                          color: Colors.white,
                          size: 18,
                          font: 'inconsolata',
                          weight: FontWeight.w700,
                        ),
                        BorderView(
                          bottom: true,
                          bottomColor: Colors.white,
                          bottomWidth: 1,
                          child: TextfieldView(
                            controller: widget.dm.taskTextController,
                            backgroundColor: Colors.transparent,
                            color: Colors.white,
                            placeholderColor: Colors.white60,
                            size: 20,
                            maxLines: 5,
                            placeholder: 'ex. create a bagel for everything.',
                            multiline: true,
                            isCap: true,
                            isAutoCorrect: true,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        // CATEGORY
                        const TextView(
                          text: 'category',
                          color: Colors.white,
                          size: 18,
                          font: 'inconsolata',
                          weight: FontWeight.w700,
                        ),
                        BorderView(
                          bottom: true,
                          bottomColor: Colors.white,
                          bottomWidth: 1,
                          child: TextfieldView(
                            controller: widget.dm.categoryTextController,
                            backgroundColor: Colors.transparent,
                            color: Colors.white,
                            placeholderColor: Colors.white60,
                            size: 20,
                            maxLines: 1,
                            placeholder:
                                'ex. school work, personal, bagel project..',
                            isCap: true,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        // DATE
                        const TextView(
                          text: 'date',
                          color: Colors.white,
                          size: 18,
                          font: 'inconsolata',
                          weight: FontWeight.w700,
                        ),
                        BorderView(
                          bottom: true,
                          bottomColor: Colors.white,
                          bottomWidth: 1,
                          child: TextfieldView(
                            controller: widget.dm.dateTextController,
                            backgroundColor: Colors.transparent,
                            color: Colors.white,
                            placeholderColor: Colors.white60,
                            size: 20,
                            maxLines: 5,
                            placeholder: 'ex. today, 12/25/1995, July 25..',
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        // DATE
                        const TextView(
                          text: 'priority',
                          color: Colors.white,
                          size: 18,
                          font: 'inconsolata',
                          weight: FontWeight.w700,
                        ),
                        DropdownView(
                            defaultValue: widget.dm.priority,
                            items: const ['LOW', 'MEDIUM', 'HIGH'],
                            backgroundColor: hexToColor("#12161D"),
                            textColor: Colors.white,
                            onChanged: (value) {
                              setState(() {
                                widget.dm.setPriority(value);
                              });
                            })
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // BUTTON HERE
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ButtonView(
                                child: const Row(
                                  children: [
                                    TextView(
                                      text: 'save changes',
                                      color: Colors.white,
                                      size: 21,
                                      font: 'inconsolata',
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Icon(
                                      Icons.save_outlined,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                                onPress: () {
                                  onUpdateTask();
                                })
                          ],
                        ),
                        const SizedBox(
                          height: 35,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
            ),
          ),

          // ABSOLUTE
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
