import 'package:coco_ai_assistant/COMPONENTS/accordion_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/alert_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/border_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/button_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/checkbox_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/dropdown_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/future_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/loading_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/padding_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/roundedcorners_view.dart';
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
import 'package:coco_ai_assistant/VIEWS/WIDGETS/Flashcards/flashcards_new_widget.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/Flashcards/flashcards_study_widget.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/Journal/journal_new_widget.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/Tasks/tasks_new_widget.dart';
import 'package:flutter/material.dart';

class FlashcardsFullWidget extends StatefulWidget {
  DataMaster dm;
  FlashcardsFullWidget({super.key, required this.dm});

  @override
  State<FlashcardsFullWidget> createState() => _FlashcardsFullWidgetState();
}

class _FlashcardsFullWidgetState extends State<FlashcardsFullWidget> {
  // VARIABLES

  Future<dynamic> _fetchFlashcards() async {
    final stackDocs =
        await firebase_GetAllDocumentsQueried('${appName}_Flashcards', [
      {'field': 'userId', 'operator': '==', 'value': widget.dm.userId}
    ]);
    return stackDocs;
  }

  void onRemoveStack(stackId) async {
    setState(() {
      widget.dm.setToggleAlert(true);
      widget.dm.setAlertTitle('Remove Flashcard Stack');
      widget.dm.setAlertText(
          'Are you sure you want to remove this flashcard stack?');
      widget.dm.setAlertButtons([
        ButtonView(
            child: TextView(
              text: 'Remove',
              color: hexToColor("#FF1F6E"),
              size: 20,
              font: 'inconsolata',
            ),
            onPress: () async {
              setState(() {
                widget.dm.setToggleAlert(false);
                widget.dm.setToggleLoading(true);
              });
              final success = await firebase_DeleteDocument(
                  '${appName}_Flashcards', stackId);
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
          Column(
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
                              text: 'Flashcards',
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
                          // NEW FLASHCARD STACK
                          nav_Push(context, FlashcardsNewWidget(dm: widget.dm),
                              () {
                            setState(() {});
                          });
                        })
                  ],
                )),
              ),

              //  FLASHCARD STACKS HERE

              SingleChildScrollView(
                child: FutureView(
                    future: _fetchFlashcards(),
                    childBuilder: (data) {
                      return Column(
                        children: [
                          for (var stack
                              in sortArrayByProperty(data, 'stackName'))
                            BorderView(
                              bottom: true,
                              bottomColor: Colors.white30,
                              child: PaddingView(
                                  child: AccordionView(
                                      topWidget: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextView(
                                            text: '${stack['stackName']} Stack',
                                            color: Colors.white,
                                            size: 24,
                                            weight: FontWeight.w600,
                                            font: 'inconsolata',
                                          ),
                                          const Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.white,
                                            size: 38,
                                          )
                                        ],
                                      ),
                                      bottomWidget: PaddingView(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            ButtonView(
                                                child: TextView(
                                                  text: 'edit',
                                                  color: hexToColor("#1576D2"),
                                                  size: 20,
                                                  font: 'inconsolata',
                                                ),
                                                onPress: () {
                                                  // EDIT FLASHCARDS
                                                }),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            ButtonView(
                                                child: TextView(
                                                  text: 'remove',
                                                  color: hexToColor("#FF1F6E"),
                                                  size: 20,
                                                  font: 'inconsolata',
                                                ),
                                                onPress: () {
                                                  // REMOVE FLASHCARDS
                                                  onRemoveStack(stack['id']);
                                                }),
                                            const SizedBox(
                                              width: 30,
                                            ),
                                            ButtonView(
                                                child: TextView(
                                                  text: 'study',
                                                  color: hexToColor("#8EB8ED"),
                                                  size: 20,
                                                  font: 'inconsolata',
                                                ),
                                                onPress: () {
                                                  // STUDY FLASHCARDS
                                                  nav_Push(
                                                      context,
                                                      FlashcardsStudyWidget(
                                                          dm: widget.dm,
                                                          stack: stack), () {
                                                    setState(() {});
                                                  });
                                                }),
                                          ],
                                        ),
                                      ))),
                            )
                        ],
                      );
                    },
                    emptyWidget: const PaddingView(
                        child: Center(
                      child: TextView(
                        text: 'No flashcard stacks yet.',
                        color: Colors.white,
                        size: 18,
                        font: 'inconsolata',
                      ),
                    ))),
              )
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
                        wrap: false,
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
