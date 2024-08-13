import 'package:coco_ai_assistant/COMPONENTS/blur_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/button_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/roundedcorners_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/scrollable_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/textfield_view.dart';
import 'package:coco_ai_assistant/FUNCTIONS/nav.dart';
import 'package:coco_ai_assistant/MASTER/datamaster.dart';
import 'package:coco_ai_assistant/MODELS/firebase.dart';
import 'package:coco_ai_assistant/MODELS/screen.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/flashcards_widget.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/journal_widget.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/notes_widget.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/tasks_widget.dart';
import 'package:coco_ai_assistant/VIEWS/coco_type.dart';
import 'package:coco_ai_assistant/VIEWS/signup.dart';
import 'package:flutter/material.dart';
import 'package:coco_ai_assistant/COMPONENTS/loading_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/padding_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/text_view.dart';
import 'package:coco_ai_assistant/FUNCTIONS/colors.dart';

class Home extends StatefulWidget {
  DataMaster dm;
  Home({super.key, required this.dm});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void init() async {
    // auth_SignOut();
    final user = await auth_CheckUser();
    if (user == null) {
      nav_PushAndRemove(context, SignUp(dm: widget.dm));
    } else {
      setState(() {
        widget.dm.setUserId(user.uid);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    init();
    return Scaffold(
      backgroundColor: hexToColor(widget.dm.backgroundColor),
      body: Stack(
        children: [
          // MAIN
          SizedBox(
            height: getHeight(context),
            width: getWidth(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TOP
                const SizedBox(
                  height: 50,
                ),
                const PaddingView(
                  paddingTop: 0,
                  paddingBottom: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextView(
                        text: 'hello, my name is Coco..',
                        color: Colors.white,
                        font: 'inconsolata',
                        size: 17,
                        weight: FontWeight.w500,
                      ),
                      TextView(
                        text: 'ver. 1.1',
                        color: Colors.white70,
                        font: 'inconsolata',
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TasksWidget(
                          dm: widget.dm,
                        ),
                        NotesWidget(dm: widget.dm),
                        FlashcardsWidget(dm: widget.dm),
                        JournalWiget(
                          dm: widget.dm,
                        ),
                        const SizedBox(
                          height: 100,
                        ),
                      ],
                    ),
                  ),
                )
                // BODY
              ],
            ),
          ),

          // ABSOLUTE
          //
          if (widget.dm.toggleShowOptions)
            Positioned(
              bottom: 40,
              right: 12,
              child: Column(
                children: [
                  Row(
                    children: [
                      ButtonView(
                          child: const TextView(
                            text: 'voice command',
                            size: 22,
                            color: Colors.white,
                            font: 'inconsolata',
                          ),
                          onPress: () {
                            setState(() {
                              widget.dm.setToggleShowOptions(false);
                            });
                          }),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(Icons.keyboard_double_arrow_right,
                          color: Colors.white)
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      ButtonView(
                          child: const TextView(
                            text: 'type command',
                            size: 22,
                            color: Colors.white,
                            font: 'inconsolata',
                          ),
                          onPress: () {
                            setState(() {
                              widget.dm.setToggleShowOptions(false);
                            });
                            nav_Push(context, CocoType(dm: widget.dm));
                          }),
                      const SizedBox(
                        width: 10,
                      ),
                      const Icon(Icons.keyboard_double_arrow_right,
                          color: Colors.white)
                    ],
                  ),
                ],
              ),
            ),
          if (!widget.dm.toggleShowOptions)
            Positioned(
                bottom: 40,
                right: 12,
                child: ButtonView(
                  radius: 100,
                  backgroundColor: hexToColor("#000000"),
                  onPress: () {
                    setState(() {
                      widget.dm.setToggleShowOptions(true);
                    });
                  },
                  child: const PaddingView(
                    paddingTop: 6,
                    paddingBottom: 6,
                    paddingLeft: 16,
                    paddingRight: 16,
                    child: TextView(
                      text: 'coco command',
                      size: 20,
                      font: 'inconsolata',
                      color: Colors.white,
                    ),
                  ),
                )),
          //
          // TOGGLES
          if (widget.dm.toggleLoading) const LoadingView()
        ],
      ),
    );
  }
}
