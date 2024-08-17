import 'package:coco_ai_assistant/COMPONENTS/accordion_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/alert_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/border_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/button_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/dropdown_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/loading_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/padding_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/roundedcorners_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/text_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/textfield_view.dart';
import 'package:coco_ai_assistant/FUNCTIONS/array.dart';
import 'package:coco_ai_assistant/FUNCTIONS/colors.dart';
import 'package:coco_ai_assistant/FUNCTIONS/nav.dart';
import 'package:coco_ai_assistant/MASTER/datamaster.dart';
import 'package:coco_ai_assistant/MODELS/JOBS/coco_jobs.dart';
import 'package:coco_ai_assistant/MODELS/coco.dart';
import 'package:coco_ai_assistant/MODELS/screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FlashcardsStudyWidget extends StatefulWidget {
  DataMaster dm;
  Map<String, dynamic> stack;
  FlashcardsStudyWidget({super.key, required this.dm, required this.stack});

  @override
  State<FlashcardsStudyWidget> createState() => _FlashcardsStudyWidgetState();
}

class _FlashcardsStudyWidgetState extends State<FlashcardsStudyWidget> {
  List<dynamic> tempCards = [];

  void shuffleCards() {
    final temp = shuffleArray(List.from(widget.stack['flashcards']));
    setState(() {
      tempCards = [];
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        tempCards = temp;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      tempCards = shuffleArray(List.from(widget.stack['flashcards']));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexToColor(widget.dm.backgroundColor),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                        text: 'Flashcard Study',
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

                  // FLASHCARDS AND INFO HERE
                  //
                  RoundedCornersView(
                    child: Container(
                      color: Colors.white10,
                      child: PaddingView(
                        child: Row(
                          children: [
                            Icon(
                              Icons.priority_high,
                              color: hexToColor("#1576D2"),
                              size: 30,
                            ),
                            const TextView(
                              text: 'Tap on the card to view the answer.',
                              color: Colors.white,
                              size: 20,
                              font: 'inconsolata',
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  for (var pair in tempCards)
                    SizedBox(
                      width: double.infinity,
                      child: PaddingView(
                        paddingTop: 0,
                        paddingLeft: 0,
                        paddingRight: 0,
                        paddingBottom: 10,
                        child: RoundedCornersView(
                          child: AccordionView(
                            topWidget: Container(
                              color: Colors.white10,
                              child: PaddingView(
                                paddingTop: 15,
                                paddingBottom: 15,
                                child: Center(
                                  child: TextView(
                                    text: pair['front'],
                                    color: Colors.white,
                                    size: 24,
                                    font: 'inconsolata',
                                  ),
                                ),
                              ),
                            ),
                            bottomWidget: Container(
                              color: Colors.white24,
                              child: PaddingView(
                                child: Center(
                                  child: TextView(
                                    text: pair['back'],
                                    color: Colors.white,
                                    size: 24,
                                    font: 'inconsolata',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  //
                  //
                  const SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
          ),

          // ABSOLUTE
          Positioned(
            bottom: 30,
            right: 10,
            child: ButtonView(
                backgroundColor: Colors.black54,
                radius: 100,
                paddingTop: 8,
                paddingBottom: 8,
                paddingLeft: 18,
                paddingRight: 18,
                child: const TextView(
                  text: 'shuffle',
                  color: Colors.white,
                  size: 20,
                  font: 'inconsolata',
                ),
                onPress: () {
                  shuffleCards();
                  setState(() {});
                }),
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
