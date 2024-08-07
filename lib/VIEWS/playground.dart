import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:coco_ai_assistant/COMPONENTS/accordion_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/blur_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/button_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/checkbox_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/dropdown_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/fade_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/loading_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/map_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/padding_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/pager_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/roundedcorners_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/scrollable_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/segmented_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/separated_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/split_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/switch_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/text_view.dart';
import 'package:coco_ai_assistant/FUNCTIONS/colors.dart';
import 'package:coco_ai_assistant/FUNCTIONS/date.dart';
import 'package:coco_ai_assistant/FUNCTIONS/misc.dart';
import 'package:coco_ai_assistant/FUNCTIONS/recorder.dart';
import 'package:coco_ai_assistant/FUNCTIONS/server.dart';
import 'package:coco_ai_assistant/MODELS/coco.dart';
import 'package:coco_ai_assistant/MODELS/firebase.dart';
import 'package:coco_ai_assistant/MODELS/screen.dart';
import 'package:record/record.dart';

class PlaygroundView extends StatefulWidget {
  const PlaygroundView({Key? key}) : super(key: key);

  @override
  State<PlaygroundView> createState() => _PlaygroundViewState();
}

class _PlaygroundViewState extends State<PlaygroundView> {
  String _selected = "One";
  Sound recorder = Sound();
  bool _isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        const SizedBox(
          height: 100,
        ),
        const Center(
          child: TextView(
            text: "IIC App Template, WELCOME!",
            align: TextAlign.center,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        // -------------------

        Container(
          height: 70,
          child: PagerView(
            children: [
              const TextView(text: "HELLO"),
              const TextView(text: "GOODBYE BAGEL")
            ],
          ),
        ),

        ButtonView(
            paddingTop: 8,
            paddingBottom: 8,
            paddingLeft: 14,
            paddingRight: 14,
            radius: 100,
            backgroundColor: hexToColor("#F8F8F8"),
            child: const TextView(text: "PRESS ME"),
            onPress: () async {
              final response = await server_POST('synthesize', {
                'text':
                    'Welcome to the Innovative Internet Creations Flutter App Template.'
              });
              final List<int> audioData =
                  List<int>.from(response["audio"]["data"]);
              final filePath = await writeToFile(audioData);
              recorder.audioPath = filePath;
              recorder.playRecording();
            })
      ],
    ));
  }
}
