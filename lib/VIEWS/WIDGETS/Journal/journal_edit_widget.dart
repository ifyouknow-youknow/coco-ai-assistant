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
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class JournalEditWidget extends StatefulWidget {
  DataMaster dm;
  Map<String, dynamic> entry;
  JournalEditWidget({super.key, required this.dm, required this.entry});

  @override
  State<JournalEditWidget> createState() => _JournalEditWidgetState();
}

class _JournalEditWidgetState extends State<JournalEditWidget> {
  @override
  void initState() {
    widget.dm.init_titleTextController();
    widget.dm.init_entryTextController();
    widget.dm.titleTextController.text = widget.entry['title'];
    widget.dm.entryTextController.text =
        widget.entry['entry'].replaceAll('\\n', '\n');
    super.initState();
  }

  @override
  void dispose() {
    widget.dm.disposeAll();
    super.dispose();
  }

  void onUpdateEntry() async {
    final _title = widget.dm.titleTextController.text;
    final _entry = widget.dm.entryTextController.text;

    if (_title.isEmpty || _entry.isEmpty) {
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
        'UserId: ${widget.dm.userId}. You are a journal manager. Your job is to update journal entries based on user input.',
        declarationList);

    final response = await coco_SendChat(
        chat,
        'Update a journal entry for me: Id: ${widget.entry['id']}  Title: $_title. Entry: $_entry. Make sure to create a summary based on this information.',
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
                          text: 'edit journal entry',
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                placeholder: 'ex. an entrance to the bagel.',
                                isAutoCorrect: true,
                                isCap: true,
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            // CATEGORY
                            const TextView(
                              text: 'entry',
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
                                controller: widget.dm.entryTextController,
                                backgroundColor: Colors.transparent,
                                color: Colors.white,
                                placeholderColor: Colors.white60,
                                size: 20,
                                maxLines: 20,
                                placeholder: 'type anything you want..',
                                multiline: true,
                                isAutoCorrect: true,
                                isCap: true,
                              ),
                            ),
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
                                      onUpdateEntry();
                                    })
                              ],
                            ),
                            const SizedBox(
                              height: 35,
                            )
                          ],
                        )
                      ],
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
