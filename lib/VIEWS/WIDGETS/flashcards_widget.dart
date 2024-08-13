import 'package:coco_ai_assistant/COMPONENTS/border_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/button_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/checkbox_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/padding_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/text_view.dart';
import 'package:coco_ai_assistant/FUNCTIONS/array.dart';
import 'package:coco_ai_assistant/FUNCTIONS/colors.dart';
import 'package:coco_ai_assistant/FUNCTIONS/nav.dart';
import 'package:coco_ai_assistant/MASTER/datamaster.dart';
import 'package:coco_ai_assistant/MODELS/constants.dart';
import 'package:coco_ai_assistant/MODELS/firebase.dart';
import 'package:coco_ai_assistant/MODELS/screen.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/flashcards_full_widget.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/notes_full_widget.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/tasks_full_widget.dart';
import 'package:flutter/material.dart';

class FlashcardsWidget extends StatefulWidget {
  DataMaster dm;
  FlashcardsWidget({super.key, required this.dm});

  @override
  State<FlashcardsWidget> createState() => _FlashcardsWidgetState();
}

class _FlashcardsWidgetState extends State<FlashcardsWidget> {
  void init() async {
    // GET ALL CARDS
    final tempStacks = await widget.dm.getFlashcards();
    setState(() {
      widget.dm.setFlashcards(tempStacks);
    });
  }

  @override
  Widget build(BuildContext context) {
    init();
    return SizedBox(
      width: getWidth(context),
      child: BorderView(
        top: true,
        topColor: Colors.white10,
        bottom: true,
        bottomColor: Colors.white10,
        child: PaddingView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: ButtonView(
                  onPress: () {
                    setState(() {
                      //  TOGGLE CARDS
                      widget.dm.setToggleFlashcardsWidget(
                          !widget.dm.toggleFlashcardsWidget);
                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(
                            Icons.dashboard_outlined,
                            color: Colors.white70,
                            size: 22,
                          ),
                          SizedBox(
                            width: 6,
                          ),
                          TextView(
                            text: 'Flashcards',
                            color: Colors.white,
                            size: 22,
                            font: 'inconsolata',
                            weight: FontWeight.w600,
                          ),
                        ],
                      ),
                      ButtonView(
                          child: Icon(
                            widget.dm.toggleFlashcardsWidget
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down,
                            size: 38,
                            color: Colors.white60,
                          ),
                          onPress: () async {
                            setState(() {
                              widget.dm.setToggleFlashcardsWidget(true);
                            });
                          })
                    ],
                  ),
                ),
              ),

              // NOTES
              if (widget.dm.toggleFlashcardsWidget)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 6,
                    ),
                    TextView(
                      text: 'Stacks',
                      color: hexToColor("#8EB8ED"),
                      size: 22,
                      font: 'inconsolata',
                      weight: FontWeight.w600,
                    ),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...widget.dm.flashcards.map<Widget>((ting) {
                            return TextView(
                              text: ting['stackName'],
                              color: Colors.white,
                              size: 22,
                              font: 'inconsolata',
                            );
                          }),
                          const SizedBox(
                            height: 8,
                          )
                        ]),
                    // MORE
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ButtonView(
                          child: const TextView(
                            text: 'see more',
                            size: 16,
                            color: Colors.white60,
                            font: 'inconsolata',
                          ),
                          onPress: () {
                            // NAV FULL WIDGET
                            nav_Push(
                                context, FlashcardsFullWidget(dm: widget.dm));
                          },
                        ),
                      ],
                    ),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
