import 'package:coco_ai_assistant/COMPONENTS/blur_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/button_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/roundedcorners_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/scrollable_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/textfield_view.dart';
import 'package:coco_ai_assistant/MODELS/screen.dart';
import 'package:coco_ai_assistant/VIEWS/coco_type.dart';
import 'package:flutter/material.dart';
import 'package:coco_ai_assistant/COMPONENTS/loading_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/padding_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/text_view.dart';
import 'package:coco_ai_assistant/FUNCTIONS/colors.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
// VARIABLES
  String _textCommand = "";

  // TOGGLES
  bool _toggleLoading = false;
  bool _toggleShowOptions = false;
  //
  bool _toggleShowType = false;

  void onToggleClose() {
    setState(() {
      _toggleShowType = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexToColor("#1D1F24"),
      body: Stack(
        children: [
          // MAIN
          SizedBox(
            height: getHeight(context),
            width: getWidth(context),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                ),
                PaddingView(
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
                )
              ],
            ),
          ),

          // ABSOLUTE
          //
          if (_toggleShowOptions)
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
                              _toggleShowOptions = false;
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
                              _toggleShowOptions = false;
                              _toggleShowType = true;
                            });
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
          if (!_toggleShowOptions)
            Positioned(
                bottom: 40,
                right: 12,
                child: ButtonView(
                  radius: 100,
                  backgroundColor: Colors.white10,
                  onPress: () {
                    setState(() {
                      _toggleShowOptions = true;
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
          if (_toggleShowType)
            CocoType(
              onToggleClose: onToggleClose,
            ),
          // TOGGLES
          if (_toggleLoading) const LoadingView()
        ],
      ),
    );
  }
}
