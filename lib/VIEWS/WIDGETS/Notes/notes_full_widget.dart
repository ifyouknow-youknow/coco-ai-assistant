import 'dart:ffi';

import 'package:coco_ai_assistant/COMPONENTS/accordion_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/alert_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/border_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/button_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/checkbox_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/dropdown_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/future_view.dart';
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
import 'package:coco_ai_assistant/VIEWS/WIDGETS/Journal/journal_new_widget.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/Notes/notes_edit_widget.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/Notes/notes_new_widget.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/Tasks/tasks_new_widget.dart';
import 'package:flutter/material.dart';

class NotesFullWidget extends StatefulWidget {
  DataMaster dm;
  NotesFullWidget({super.key, required this.dm});

  @override
  State<NotesFullWidget> createState() => _NotesFullWidgetState();
}

class _NotesFullWidgetState extends State<NotesFullWidget> {
  // VARIABLES
  Future<List<dynamic>> _fetchNotes() async {
    return await widget.dm.getNotes();
  }

  void onRemoveNote(noteId) async {
    setState(() {
      widget.dm.setToggleAlert(true);
      widget.dm.setAlertTitle('Remove Note');
      widget.dm.setAlertText('Are you sure you want to remove this note?');
      widget.dm.setAlertButtons([
        ButtonView(
            child: TextView(
              text: 'Remove',
              size: 18,
              color: hexToColor("#FF1F6E"),
            ),
            onPress: () async {
              // REMOVE
              setState(() {
                widget.dm.setToggleLoading(true);
              });
              final success =
                  await firebase_DeleteDocument('${appName}_Notes', noteId);
              if (success) {
                setState(() {
                  widget.dm.setToggleLoading(false);
                  widget.dm.setToggleAlert(false);
                });
              }
            })
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexToColor(widget.dm.backgroundColor),
      body: Stack(
        children: [
          // MAIN

          // TOP
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
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
                                text: 'Notes',
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
                            // NEW JOURNAL ENTRY
                            nav_Push(context, NotesNewWidget(dm: widget.dm),
                                () {
                              setState(() {});
                            });
                          })
                    ],
                  )),
                ),

                // BODY
                FutureView(
                    future: _fetchNotes(),
                    childBuilder: (data) {
                      return Column(
                        children: [
                          for (var folder in removeDupes(
                              data.map((ting) => ting['folder']).toList()))
                            BorderView(
                              bottom: true,
                              bottomColor: Colors.white38,
                              child: AccordionView(
                                  topWidget: PaddingView(
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.folder_outlined,
                                          color: hexToColor("#8EB8ED"),
                                          size: 28,
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        TextView(
                                          text: '$folder folder',
                                          size: 22,
                                          color: Colors.white,
                                          font: 'inconsolata',
                                        )
                                      ],
                                    ),
                                  ),
                                  bottomWidget: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      for (var note in sortArrayByProperty(
                                          data
                                              .where((ting) =>
                                                  ting['folder'] == folder)
                                              .toList(),
                                          'title'))
                                        AccordionView(
                                            topWidget: PaddingView(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  const Icon(
                                                    Icons.draw_outlined,
                                                    color: Colors.white70,
                                                    size: 26,
                                                  ),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  TextView(
                                                    text: note['title'],
                                                    color: Colors.white,
                                                    size: 22,
                                                    font: 'inconsolata',
                                                    weight: FontWeight.w600,
                                                  )
                                                ],
                                              ),
                                            ),
                                            bottomWidget: PaddingView(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  TextView(
                                                    text:
                                                        'Summary:\n${note['summary']}',
                                                    color: Colors.white,
                                                    size: 18,
                                                    font: 'inconsolata',
                                                  ),
                                                  const SizedBox(
                                                    height: 20,
                                                  ),
                                                  TextView(
                                                    text:
                                                        'Note:\n${note['note'].replaceAll("\\n", '\n')}',
                                                    color: Colors.white,
                                                    size: 18,
                                                    font: 'inconsolata',
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      ButtonView(
                                                          child: TextView(
                                                            text: 'edit',
                                                            color: hexToColor(
                                                                "#1576D2"),
                                                            font: 'inconsolata',
                                                            size: 20,
                                                          ),
                                                          onPress: () {
                                                            // GO TO EDIT NOTE PAGE
                                                            nav_Push(
                                                                context,
                                                                NotesEditWidget(
                                                                    dm: widget
                                                                        .dm,
                                                                    note: note),
                                                                () {
                                                              setState(() {});
                                                            });
                                                          }),
                                                      const SizedBox(
                                                        width: 15,
                                                      ),
                                                      ButtonView(
                                                          child: TextView(
                                                            text: 'remove',
                                                            color: hexToColor(
                                                                "#FF1F6E"),
                                                            font: 'inconsolata',
                                                            size: 20,
                                                          ),
                                                          onPress: () {
                                                            // REMOVE
                                                            onRemoveNote(
                                                                note['id']);
                                                          }),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  const TextView(
                                                    text:
                                                        "............................",
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                            ))
                                    ],
                                  )),
                            )
                        ],
                      );
                    },
                    emptyWidget: const PaddingView(
                      child: Center(
                        child: TextView(
                          text: 'No notes found.',
                          size: 20,
                          color: Colors.white,
                          font: 'inconsolata',
                        ),
                      ),
                    ))
              ],
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
