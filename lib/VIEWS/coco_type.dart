import 'package:coco_ai_assistant/COMPONENTS/border_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/image_view.dart';
import 'package:coco_ai_assistant/FUNCTIONS/colors.dart';
import 'package:coco_ai_assistant/FUNCTIONS/date.dart';
import 'package:coco_ai_assistant/FUNCTIONS/misc.dart';
import 'package:coco_ai_assistant/FUNCTIONS/nav.dart';
import 'package:coco_ai_assistant/MASTER/datamaster.dart';
import 'package:coco_ai_assistant/MODELS/JOBS/coco_jobs.dart';
import 'package:flutter/material.dart';
import 'package:coco_ai_assistant/COMPONENTS/blur_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/button_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/padding_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/text_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/textfield_view.dart';
import 'package:coco_ai_assistant/MODELS/JOBS/instructions.dart';
import 'package:coco_ai_assistant/MODELS/coco.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class CocoType extends StatefulWidget {
  DataMaster dm;
  CocoType({super.key, required this.dm});

  @override
  State<CocoType> createState() => _CocoTypeState();
}

class _CocoTypeState extends State<CocoType> {
  String _copiedText = "";
  //
  bool _toggleCopied = false;
  bool isThinking = false;

  void onCoco() async {
    setState(() {
      isThinking = true;
    });
    final tempCommand = widget.dm.chatTextController.text;
    widget.dm.chatTextController.clear();

    final userRes = {
      'date': DateTime.now(),
      'message': tempCommand,
      'role': 'you',
      'id': randomString(12)
    };
    setState(() {
      widget.dm.addToResponses(userRes);
    });

    final response =
        await coco_SendChat(widget.dm.chat, tempCommand, functionMap);
    if (response != null) {
      final cocoRes = {
        'date': DateTime.now(),
        'message': response.trim().replaceAll('**', ""),
        'role': 'coco',
        'id': randomString(12)
      };
      setState(() {
        widget.dm.addToResponses(cocoRes);
        isThinking = false;
      });
    }
  }

  void _init() async {
    final tempChat = await coco_StartCustomChat(
        'userId: ${widget.dm.userId}. $main_instructions', declarationList);
    setState(() {
      widget.dm.setChat(tempChat);
    });
  }

  @override
  void initState() {
    widget.dm.init_chatTextController();
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexToColor(widget.dm.backgroundColor),
      body: Stack(
        children: [
          BlurView(
            child: Column(
              children: [
                Expanded(
                    child: Column(
                  children: [
                    const SizedBox(
                      height: 50,
                    ),
                    // TOP
                    PaddingView(
                      paddingTop: 0,
                      paddingBottom: 8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const TextView(
                            text: 'coco chat',
                            font: 'inconsolata',
                            size: 24,
                            color: Colors.white,
                            weight: FontWeight.w700,
                          ),
                          ButtonView(
                              child: const Row(
                                children: [
                                  TextView(
                                    text: 'close',
                                    size: 20,
                                    color: Colors.white,
                                    font: 'inconsolata',
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
                                widget.dm.setResponses([]);
                                nav_Pop(context);
                              })
                        ],
                      ),
                    ), //
                    // CHAT
                    Flexible(
                      child: PaddingView(
                        paddingTop: 0,
                        paddingBottom: 0,
                        child: SingleChildScrollView(
                            reverse: true,
                            physics: const ScrollPhysics(),
                            child: Column(children: [
                              ...widget.dm.responses.map<Widget>((res) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        TextView(
                                          text: '${res['role']}',
                                          color: res['role'] == 'coco'
                                              ? hexToColor("#3490F3")
                                              : Colors.white70,
                                          size: 20,
                                          font: 'inconsolata',
                                          weight: FontWeight.w600,
                                        ),
                                        const SizedBox(
                                          width: 6,
                                        ),
                                        Icon(
                                          Icons.keyboard_double_arrow_right,
                                          color: res['role'] == 'coco'
                                              ? hexToColor("#3490F3")
                                              : Colors.white70,
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        TextView(
                                          text: formatTime(res['date']),
                                          color: Colors.white70,
                                          font: 'inconsolata',
                                          size: 18,
                                        ),
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        ButtonView(
                                            child: const Icon(
                                              Icons.content_copy,
                                              color: Colors.white70,
                                              size: 18,
                                            ),
                                            onPress: () {
                                              setState(() {
                                                _copiedText = res['message'];
                                                _toggleCopied = true;
                                              });
                                              Future.delayed(
                                                  const Duration(seconds: 3),
                                                  () {
                                                setState(() {
                                                  _toggleCopied = false;
                                                });
                                              });
                                              copyToClipboard(res['message']);
                                            }),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        if (_toggleCopied &&
                                            _copiedText == res['message'])
                                          const TextView(
                                            text: 'copied!',
                                            size: 15,
                                            color: Colors.white,
                                          )
                                      ],
                                    ),
                                    TextView(
                                        text: res['message'],
                                        color: Colors.white,
                                        size: 20,
                                        font: 'inconsolata'),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    const TextView(
                                      text:
                                          ".......................................",
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    )
                                  ],
                                );
                              }),
                              const SizedBox(
                                height: 100,
                              )
                            ])),
                      ),
                    )
                  ],
                ))
              ],
            ),
          ),

          // BOTTOM
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BorderView(
              top: true,
              topColor: Colors.white12,
              child: Container(
                color: Colors.black,
                child: PaddingView(
                    paddingTop: 0,
                    paddingBottom: 30,
                    paddingRight: 15,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: TextfieldView(
                            paddingH: 0,
                            controller: widget.dm.chatTextController,
                            placeholder: 'tell me what to do..',
                            placeholderColor: Colors.white70,
                            size: 20,
                            color: Colors.white,
                            maxLines: 15,
                            isAutoCorrect: true,
                            multiline: true,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        ButtonView(
                            child: const TextView(
                              text: 'submit',
                              color: Colors.white,
                              size: 20,
                              font: 'inconsolata',
                            ),
                            onPress: () {
                              onCoco();
                            })
                      ],
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
