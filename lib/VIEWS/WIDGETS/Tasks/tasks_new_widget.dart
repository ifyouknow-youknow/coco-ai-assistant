import 'package:coco_ai_assistant/COMPONENTS/alert_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/border_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/button_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/dropdown_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/loading_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/padding_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/text_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/textfield_view.dart';
import 'package:coco_ai_assistant/FUNCTIONS/colors.dart';
import 'package:coco_ai_assistant/FUNCTIONS/nav.dart';
import 'package:coco_ai_assistant/MASTER/datamaster.dart';
import 'package:coco_ai_assistant/MODELS/JOBS/coco_jobs.dart';
import 'package:coco_ai_assistant/MODELS/coco.dart';
import 'package:coco_ai_assistant/MODELS/screen.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/Tasks/tasks_full_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class TasksNewWidget extends StatefulWidget {
  DataMaster dm;
  TasksNewWidget({super.key, required this.dm});

  @override
  State<TasksNewWidget> createState() => _TasksNewWidgetState();
}

class _TasksNewWidgetState extends State<TasksNewWidget> {
  @override
  void initState() {
    widget.dm.init_taskTextController();
    widget.dm.init_categoryTextController();
    widget.dm.init_dateTextController();
    super.initState();
  }

  void onCreateTask() async {
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
        'UserId: ${widget.dm.userId}. You are a task manager that creates tasks.',
        declarationList);

    final response = await coco_SendChat(
        chat,
        'Create a task for me: Task: $_task. Category: $_category. Date: $_date. Priority: $_priority.',
        functionMap);

    setState(() {
      widget.dm.setToggleLoading(false);
      widget.dm.getTasks(DateTime.now());
    });

    nav_Pop(context);
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
                          text: 'new task',
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
                            placeholder:
                                'ex. complete outline for the bagel department.',
                            isAutoCorrect: true,
                            isCap: true,
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
                                      text: 'create',
                                      color: Colors.white,
                                      size: 21,
                                      font: 'inconsolata',
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Icon(
                                      Icons.add,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                                onPress: () {
                                  onCreateTask();
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
