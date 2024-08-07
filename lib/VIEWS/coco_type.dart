import 'package:coco_ai_assistant/FUNCTIONS/colors.dart';
import 'package:coco_ai_assistant/FUNCTIONS/date.dart';
import 'package:coco_ai_assistant/FUNCTIONS/misc.dart';
import 'package:coco_ai_assistant/MODELS/JOBS/jobs.dart';
import 'package:coco_ai_assistant/MODELS/JOBS/tasks.dart';
import 'package:flutter/material.dart';
import 'package:coco_ai_assistant/COMPONENTS/blur_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/button_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/padding_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/scrollable_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/text_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/textfield_view.dart';
import 'package:coco_ai_assistant/MODELS/JOBS/instructions.dart';
import 'package:coco_ai_assistant/MODELS/coco.dart';
import 'package:coco_ai_assistant/MODELS/screen.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class CocoType extends StatefulWidget {
  final Function onToggleClose;
  CocoType({super.key, required this.onToggleClose});

  @override
  State<CocoType> createState() => _CocoTypeState();
}

class _CocoTypeState extends State<CocoType> {
  late String _userId;
  late TextEditingController _controller;
  ChatSession? chat;
  List<Map<String, dynamic>> responses = [];
  String _currentJob = "jobs";
  String _copiedText = "";
  //
  bool _toggleCopied = false;

  void onCoco() async {
    final tempCommand = _controller.text;
    _controller.clear();
    final userRes = {
      'date': DateTime.now(),
      'message': tempCommand,
      'role': 'you',
      'id': randomString(12)
    };
    setState(() {
      responses.add(userRes);
    });
    String? response = "";

    if (_currentJob == 'jobs') {
      response = await coco_SendChat(chat!, tempCommand, jobFunctions);
    }
    //
    if (response == 'tasks') {
      final newChat = await coco_StartCustomChat(
          'userId: $_userId. $main_instructions. $tasks_instructions',
          declarations_tasks);
      setState(() {
        chat = newChat;
      });
      setState(() {
        _currentJob = 'tasks';
      });
    }
    if (_currentJob == 'tasks') {
      final response = await coco_SendChat(
          chat!,
          'The user said this: $tempCommand. Make sure you have all information that you need before calling a function.',
          taskFunctions);
      final tempResponse = {
        'date': DateTime.now(),
        'message':
            response!.trimRight().replaceAll('**', '').replaceAll('##', ''),
        'role': 'coco',
        'id': randomString(12)
      };
      setState(() {
        responses.add(tempResponse);
      });
    } else if (response != null) {
      // ALL ELSE
      final tempResponse = {
        'date': DateTime.now(),
        'message':
            response.trimRight().replaceAll('**', '').replaceAll('##', ''),
        'role': 'coco',
        'id': randomString(12)
      };
      setState(() {
        responses.add(tempResponse);
      });
    }
  }

  void _init() async {
    var userId = await getInDevice('userId');
    if (userId == null) {
      final newUserId = randomString(25);
      setInDevice('userId', newUserId);
      userId = newUserId;
    }
    setState(() {
      _userId = userId;
    });
    final tempChat = await coco_StartCustomChat(
        'userId: $userId. $main_instructions', [declaration_ChooseJob]);
    setState(() {
      chat = tempChat;
    });
  }

  @override
  void initState() {
    _controller = TextEditingController();
    _init();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
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
                                widget.onToggleClose();
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
                              ...responses.map<Widget>((res) {
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
                                      text: ".............................",
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
            child: Container(
              color: Colors.black,
              child: PaddingView(
                  paddingBottom: 45,
                  paddingRight: 15,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextfieldView(
                          controller: _controller,
                          placeholder: 'tell me what to do..',
                          placeholderColor: Colors.white70,
                          size: 20,
                          color: Colors.white,
                          maxLines: 15,
                          isAutoCorrect: true,
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
          )
        ],
      ),
    );
  }
}
