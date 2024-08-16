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
import 'package:coco_ai_assistant/VIEWS/WIDGETS/Journal/journal_edit_widget.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/Journal/journal_new_widget.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/Tasks/tasks_new_widget.dart';
import 'package:flutter/material.dart';

class JournalFullWidget extends StatefulWidget {
  DataMaster dm;
  JournalFullWidget({super.key, required this.dm});

  @override
  State<JournalFullWidget> createState() => _JournalFullWidgetState();
}

class _JournalFullWidgetState extends State<JournalFullWidget> {
  // VARIABLES
  Future<dynamic> _fetchEntries() async {
    return await widget.dm.getJournalEntries();
  }

  void onRemoveEntry(entryId) async {
    setState(() {
      widget.dm.setToggleAlert(true);
      widget.dm.setAlertTitle('Remove Entry');
      widget.dm.setAlertText('Are you sure you want to remove this entry?');
      widget.dm.setAlertButtons([
        ButtonView(
            child: TextView(
              text: 'Remove',
              color: hexToColor("#FF1F6E"),
              size: 18,
            ),
            onPress: () async {
              setState(() {
                widget.dm.setToggleAlert(false);
                widget.dm.setToggleLoading(true);
              });

              final success = await firebase_DeleteDocument(
                  '${appName}_JournalEntries', entryId);
              if (success) {
                setState(() {
                  widget.dm.setToggleLoading(false);
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
                                text: 'Journal Entries',
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
                            nav_Push(context, JournalNewWidget(dm: widget.dm),
                                () {
                              setState(() {});
                            });
                          })
                    ],
                  )),
                ),
                // BODY
                Column(
                  children: [
                    FutureView(
                      future: _fetchEntries(),
                      childBuilder: (data) {
                        return Column(
                          children: [
                            for (var entry in data)
                              BorderView(
                                bottom: true,
                                bottomColor: Colors.white30,
                                child: AccordionView(
                                    topWidget: PaddingView(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(
                                            Icons.description_outlined,
                                            size: 28,
                                            color: hexToColor("#8EB8ED"),
                                          ),
                                          const SizedBox(
                                            width: 12,
                                          ),
                                          Expanded(
                                            child: TextView(
                                              text: entry['title'],
                                              color: Colors.white,
                                              size: 22,
                                              font: 'inconsolata',
                                              weight: FontWeight.w600,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    bottomWidget: Column(
                                      children: [
                                        PaddingView(
                                          child: TextView(
                                            text:
                                                'Summary:\n${entry['summary']}',
                                            color: Colors.white,
                                            size: 18,
                                            font: 'inconsolata',
                                          ),
                                        ),
                                        PaddingView(
                                          child: TextView(
                                            text:
                                                'Entry:\n${entry['entry'].replaceAll('\\n', '\n')}',
                                            color: Colors.white,
                                            size: 18,
                                            font: 'inconsolata',
                                          ),
                                        ),
                                        PaddingView(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ButtonView(
                                                  child: TextView(
                                                    text: 'edit',
                                                    color:
                                                        hexToColor("#3C96D3"),
                                                    size: 20,
                                                    font: 'inconsolata',
                                                  ),
                                                  onPress: () {
                                                    nav_Push(
                                                        context,
                                                        JournalEditWidget(
                                                          dm: widget.dm,
                                                          entry: entry,
                                                        ), () {
                                                      setState(() {});
                                                    });
                                                  }),
                                              const SizedBox(
                                                width: 15,
                                              ),
                                              ButtonView(
                                                  child: TextView(
                                                    text: 'remove',
                                                    color:
                                                        hexToColor("#FF1F6E"),
                                                    size: 20,
                                                    font: 'inconsolata',
                                                  ),
                                                  onPress: () {
                                                    onRemoveEntry(entry['id']);
                                                  })
                                            ],
                                          ),
                                        )
                                      ],
                                    )),
                              )
                          ],
                        );
                      },
                      emptyWidget: const PaddingView(
                        child: Center(
                          child: TextView(
                            text: 'No journal entries found.',
                            size: 20,
                            color: Colors.white,
                            font: 'inconsolata',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 100,
                    )
                  ],
                )
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
