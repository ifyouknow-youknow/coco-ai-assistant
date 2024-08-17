import 'dart:convert';

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
import 'package:coco_ai_assistant/FUNCTIONS/misc.dart';
import 'package:coco_ai_assistant/FUNCTIONS/nav.dart';
import 'package:coco_ai_assistant/MASTER/datamaster.dart';
import 'package:coco_ai_assistant/MODELS/JOBS/coco_jobs.dart';
import 'package:coco_ai_assistant/MODELS/coco.dart';
import 'package:coco_ai_assistant/MODELS/screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FlashcardsNewWidget extends StatefulWidget {
  DataMaster dm;
  FlashcardsNewWidget({super.key, required this.dm});

  @override
  State<FlashcardsNewWidget> createState() => _FlashcardsNewWidgetState();
}

class _FlashcardsNewWidgetState extends State<FlashcardsNewWidget> {
  List<Map<String, dynamic>> pairs = [];
  @override
  void initState() {
    widget.dm.init_titleTextController();
    widget.dm.init_frontController();
    widget.dm.init_backController();
    super.initState();
  }

  void onCreateStack() async {
    final _title = widget.dm.titleTextController.text;

    if (_title.isEmpty || pairs.isEmpty) {
      setState(() {
        widget.dm.setAlertTitle('Missing Info');
        widget.dm.setAlertText('Please provide all parts to create this stack');
        widget.dm.setToggleAlert(true);
      });
      return;
    }

    setState(() {
      widget.dm.setToggleLoading(true);
    });
    final chat = await coco_StartCustomChat(
        'UserId: ${widget.dm.userId}. You are a flashcards manager. Your job is to ucreate a flashcard stack based on user input.',
        declarationList);

    final id = randomString(25);
    final response = await coco_SendChat(
        chat,
        'Create a flashcards stack for me:Title: $_title. Flashcards: ${jsonEncode(pairs)}. Make sure to take all items and make them into a string array.',
        functionMap);

    setState(() {
      widget.dm.setToggleLoading(false);
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
                          text: 'new flashcard stack',
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
                          text: 'title',
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
                            controller: widget.dm.titleTextController,
                            backgroundColor: Colors.transparent,
                            color: Colors.white,
                            placeholderColor: Colors.white60,
                            size: 20,
                            maxLines: 1,
                            placeholder: 'ex. Japanese Hiragana 1',
                            isCap: true,
                            isAutoCorrect: true,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        // PAIRS
                        Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const TextView(
                                      text: 'front',
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
                                        controller: widget.dm.frontController,
                                        backgroundColor: Colors.transparent,
                                        color: Colors.white,
                                        placeholderColor: Colors.white60,
                                        size: 20,
                                        maxLines: 6,
                                        placeholder: '"あ"',
                                        isAutoCorrect: true,
                                        isCap: true,
                                      ),
                                    ),
                                  ],
                                )),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const TextView(
                                      text: 'back',
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
                                        controller: widget.dm.backController,
                                        backgroundColor: Colors.transparent,
                                        color: Colors.white,
                                        placeholderColor: Colors.white60,
                                        size: 20,
                                        maxLines: 6,
                                        placeholder: '"a"',
                                        isAutoCorrect: true,
                                        isCap: true,
                                      ),
                                    ),
                                  ],
                                ))
                              ],
                            ),
                            PaddingView(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ButtonView(
                                      child: TextView(
                                        text: 'add pair',
                                        color: hexToColor("#1576D2"),
                                        font: 'inconsolata',
                                        size: 20,
                                      ),
                                      onPress: () {
                                        if (widget.dm.frontController.text
                                                .isNotEmpty &&
                                            widget.dm.backController.text
                                                .isNotEmpty) {
                                          setState(() {
                                            pairs.add({
                                              'id': randomString(12),
                                              'front': widget
                                                  .dm.frontController.text,
                                              'back':
                                                  widget.dm.backController.text
                                            });
                                            widget.dm.frontController.clear();
                                            widget.dm.backController.clear();
                                          });
                                        }
                                      })
                                ],
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    // PAIRS LIST

                    for (var pair in pairs)
                      Dismissible(
                        direction: DismissDirection.endToStart,
                        background: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerRight,
                              color: Colors.red,
                              child: const PaddingView(
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            // const SizedBox(
                            //   height: 10,
                            // )
                          ],
                        ),
                        onDismissed: (direction) {
                          if (direction == DismissDirection.endToStart) {
                            setState(() {
                              pairs = removeObjById(pairs, pair['id']);
                            }); // Call your custom onRemove function
                          }
                        },
                        key: Key(pair['id']),
                        child: PaddingView(
                          paddingTop: 0,
                          paddingBottom: 10,
                          paddingRight: 0,
                          paddingLeft: 0,
                          child: RoundedCornersView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: double.infinity,
                                  child: Container(
                                    color: Colors.white10,
                                    child: PaddingView(
                                      child: TextView(
                                        text: pair['front'],
                                        color: Colors.white,
                                        size: 20,
                                        font: 'inconsolata',
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Container(
                                    color: Colors.white24,
                                    child: PaddingView(
                                      child: TextView(
                                        text: pair['back'],
                                        color: Colors.white,
                                        size: 20,
                                        font: 'inconsolata',
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    const PaddingView(
                      paddingTop: 20,
                      paddingBottom: 20,
                      child: Divider(
                        color: Colors.white38,
                      ),
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
                                  onCreateStack();
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
