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
import 'package:coco_ai_assistant/MODELS/screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GroceryNewWidget extends StatefulWidget {
  DataMaster dm;
  GroceryNewWidget({super.key, required this.dm});

  @override
  State<GroceryNewWidget> createState() => _GroceryNewWidgetState();
}

class _GroceryNewWidgetState extends State<GroceryNewWidget> {
  @override
  void initState() {
    widget.dm.init_titleTextController();
    widget.dm.init_itemsController();
    super.initState();
  }

  void onCreateList() async {
    final _title = widget.dm.titleTextController.text;
    final _items = widget.dm.itemsController.text;

    if (_title.isEmpty || _items.isEmpty) {
      setState(() {
        widget.dm.setAlertTitle('Missing Info');
        widget.dm.setAlertText(
            'Please provide all parts to create this grocery list.');
        widget.dm.setToggleAlert(true);
      });
      return;
    }

    setState(() {
      widget.dm.setToggleLoading(true);
    });

    final chat = await coco_StartCustomChat(
        'UserId: ${widget.dm.userId}. You are a grocery list manager. Your job is to create a grocery list based on user input.',
        declarationList);

    final response = await coco_SendChat(
        chat,
        'Create a grocery list for me: Title: $_title. Items: $_items. Make sure to take all items and make them into a string array.',
        functionMap);

    setState(() {
      widget.dm.setToggleLoading(false);
    });

    nav_Pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexToColor(widget.dm.backgroundColor),
      body: Stack(
        children: [
          SingleChildScrollView(
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
                        text: 'new grocery list',
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
                          placeholder: 'ex. Costco Food Items',
                          isCap: true,
                          isAutoCorrect: true,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      // CATEGORY
                      const TextView(
                        text: 'items',
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
                          controller: widget.dm.itemsController,
                          backgroundColor: Colors.transparent,
                          color: Colors.white,
                          placeholderColor: Colors.white60,
                          size: 20,
                          maxLines: 20,
                          placeholder:
                              '''- 4 tomatoes\n- 1lb lemons\n- 2 chiles\netc..''',
                          multiline: true,
                          isAutoCorrect: true,
                          isCap: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
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
                                onCreateList();
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
