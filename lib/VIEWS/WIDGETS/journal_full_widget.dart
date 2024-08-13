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

class JournalFullWidget extends StatefulWidget {
  DataMaster dm;
  JournalFullWidget({super.key, required this.dm});

  @override
  State<JournalFullWidget> createState() => _JournalFullWidgetState();
}

class _JournalFullWidgetState extends State<JournalFullWidget> {
  // VARIABLES

  void init() async {
    final tempEntries = await widget.dm.getJournalEntries();
    setState(() {
      widget.dm.setJournalEntries(tempEntries);
    });
  }

  @override
  void initState() {
    setState(() {
      widget.dm.setJournalEntries([]);
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
                            nav_Push(context, JournalNewWidget(dm: widget.dm));
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
                    children: sortArrayByProperty(
                      widget.dm.journalEntries.cast<Map<String, dynamic>>(),
                      'date',
                      desc: true,
                    ).map<Widget>((entry) {
                      return BorderView(
                        bottom: true,
                        bottomColor: Colors.white12,
                        child: PaddingView(
                          child: AccordionView(
                            topWidget: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: TextView(
                                    text: entry['title'],
                                    color: Colors.white,
                                    font: 'inconsolata',
                                    size: 20,
                                    weight: FontWeight.w700,
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  size: 36,
                                  color: Colors.white70,
                                )
                              ],
                            ),
                            bottomWidget: PaddingView(
                              paddingLeft: 0,
                              paddingRight: 0,
                              paddingTop: 15,
                              paddingBottom: 15,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextView(
                                    text: 'Summary \n${entry['summary']}',
                                    color: Colors.white,
                                    size: 20,
                                    font: 'inconsolata',
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  TextView(
                                    text: 'Entry \n${entry['entry']}',
                                    color: Colors.white,
                                    size: 20,
                                    font: 'inconsolata',
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
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
