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
import 'package:coco_ai_assistant/VIEWS/WIDGETS/tasks_new_widget.dart';
import 'package:flutter/material.dart';

class FlashcardsFullWidget extends StatefulWidget {
  DataMaster dm;
  FlashcardsFullWidget({super.key, required this.dm});

  @override
  State<FlashcardsFullWidget> createState() => _FlashcardsFullWidgetState();
}

class _FlashcardsFullWidgetState extends State<FlashcardsFullWidget> {
  // VARIABLES

  void init() async {
    // GET FLASHCARDS
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
                          })
                    ],
                  )),
              const SizedBox(
                height: 8,
              ), // BODY
              //  FLASHCARD STACKS HERE
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
