import 'package:coco_ai_assistant/COMPONENTS/blur_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/border_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/button_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/image_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/roundedcorners_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/scrollable_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/textfield_view.dart';
import 'package:coco_ai_assistant/FUNCTIONS/nav.dart';
import 'package:coco_ai_assistant/MASTER/datamaster.dart';
import 'package:coco_ai_assistant/MODELS/firebase.dart';
import 'package:coco_ai_assistant/MODELS/screen.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/Flashcards/flashcards_widget.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/Grocery/grocery_widget.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/Journal/journal_widget.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/Notes/notes_widget.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/Tasks/tasks_widget.dart';
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
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
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
                      ImageView(
                        imagePath: 'assets/coco-smile.gif',
                        width: 60,
                        height: 60,
                        objectFit: BoxFit.contain,
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
                        BorderView(
                          bottom: true,
                          bottomColor: Colors.white30,
                          child: TasksWidget(
                            dm: widget.dm,
                          ),
                        ),
                        BorderView(
                            bottom: true,
                            bottomColor: Colors.white30,
                            child: NotesWidget(dm: widget.dm)),
                        BorderView(
                            bottom: true,
                            bottomColor: Colors.white30,
                            child: FlashcardsWidget(dm: widget.dm)),
                        BorderView(
                          bottom: true,
                          bottomColor: Colors.white30,
                          child: JournalWiget(
                            dm: widget.dm,
                          ),
                        ),
                        BorderView(
                          bottom: true,
                          bottomColor: Colors.white30,
                          child: GroceryWidget(
                            dm: widget.dm,
                          ),
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
              child: BlurView(
                child: PaddingView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
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
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          ButtonView(
                              child: const TextView(
                                text: 'close',
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
                          const Icon(Icons.close, color: Colors.white)
                        ],
                      ),
                    ],
                  ),
                ),
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
