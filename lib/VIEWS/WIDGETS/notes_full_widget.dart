import 'dart:ffi';

import 'package:coco_ai_assistant/COMPONENTS/accordion_view.dart';
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
import 'package:coco_ai_assistant/VIEWS/WIDGETS/journal_new_widget.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/notes_new_widget.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/tasks_new_widget.dart';
import 'package:flutter/material.dart';

class NotesFullWidget extends StatefulWidget {
  DataMaster dm;
  NotesFullWidget({super.key, required this.dm});

  @override
  State<NotesFullWidget> createState() => _NotesFullWidgetState();
}

class _NotesFullWidgetState extends State<NotesFullWidget> {
  // VARIABLES

  void init() async {
    final tempNotes = await widget.dm.getNotes();
    setState(() {
      widget.dm.setNotes(tempNotes);
    });
  }

  @override
  void initState() {
    setState(() {
      widget.dm.setNotes([]);
    });
    init();
    super.initState();
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
                            nav_Push(context, NotesNewWidget(dm: widget.dm));
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
                    children: removeDupes(widget.dm.notes
                            .map((ting) => ting['folder'])
                            .toList()) // No need to cast to Map<String, dynamic>
                        .map<Widget>((folder) {
                      return AccordionView(
                          topWidget: BorderView(
                            bottom: true,
                            bottomColor: Colors.white12,
                            child: PaddingView(
                              child: SizedBox(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.folder_outlined,
                                      color: hexToColor("#8EB8ED"),
                                      size: 28,
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    TextView(
                                      text: folder.toUpperCase(),
                                      color: hexToColor("#8EB8ED"),
                                      size: 22,
                                      font: 'inconsolata',
                                      weight: FontWeight.w600,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          bottomWidget: BorderView(
                            bottom: true,
                            bottomColor: Colors.white30,
                            child: PaddingView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ...sortArrayByProperty(
                                          widget.dm.notes
                                              .cast<Map<String, dynamic>>()
                                              .where((note) =>
                                                  note['folder'] == folder)
                                              .toList(),
                                          'title')
                                      .map((note) {
                                    return AccordionView(
                                        topWidget: PaddingView(
                                          paddingLeft: 0,
                                          paddingRight: 0,
                                          paddingTop: 6,
                                          paddingBottom: 6,
                                          child: SizedBox(
                                            width: double.infinity,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Icon(
                                                        Icons.draw_outlined,
                                                        size: 24,
                                                        color: Colors.white54),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),
                                                    TextView(
                                                      text: note['title'],
                                                      color: Colors.white,
                                                      size: 22,
                                                      font: 'inconsolata',
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        bottomWidget: PaddingView(
                                          paddingLeft: 0,
                                          paddingRight: 0,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              TextView(
                                                text:
                                                    'Summary: \n${note['summary']}',
                                                size: 20,
                                                color: Colors.white,
                                                font: 'inconsolata',
                                              ),
                                              const SizedBox(
                                                height: 10,
                                              ),
                                              TextView(
                                                text:
                                                    'Note: \n${note['note'].replaceAll('\\n', '\n')}',
                                                size: 20,
                                                color: Colors.white,
                                                font: 'inconsolata',
                                              ),
                                              const Center(
                                                  child: PaddingView(
                                                      paddingTop: 4,
                                                      paddingBottom: 4,
                                                      paddingLeft: 4,
                                                      paddingRight: 4,
                                                      child: TextView(
                                                        text:
                                                            "..........................................",
                                                        color: Colors.white,
                                                        size: 22,
                                                      )))
                                            ],
                                          ),
                                        ));
                                  }),
                                ],
                              ),
                            ),
                          ));
                    }).toList(), // Convert the iterable to a List<Widget>
                  )),
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
