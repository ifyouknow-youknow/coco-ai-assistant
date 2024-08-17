import 'package:coco_ai_assistant/COMPONENTS/accordion_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/alert_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/border_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/button_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/checkbox_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/dropdown_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/future_view.dart';
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
import 'package:coco_ai_assistant/VIEWS/WIDGETS/Grocery/grocery_edit_widget.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/Grocery/grocery_new_widget.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/Journal/journal_new_widget.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/Tasks/tasks_new_widget.dart';
import 'package:flutter/material.dart';

class GroceryFullWidget extends StatefulWidget {
  DataMaster dm;
  GroceryFullWidget({super.key, required this.dm});

  @override
  State<GroceryFullWidget> createState() => _GroceryFullWidgetState();
}

class _GroceryFullWidgetState extends State<GroceryFullWidget> {
  // VARIABLES

  Future<dynamic> _fetchLists() async {
    final listDocs = await widget.dm.getGroceryLists();
    return listDocs;
  }

  void onRemoveList(listId) async {
    setState(() {
      widget.dm.setToggleAlert(true);
      widget.dm.setAlertTitle('Remove Grocery List');
      widget.dm
          .setAlertText('Are you sure you want to remove this grocery list?');
      widget.dm.setAlertButtons([
        ButtonView(
            child: TextView(
              text: 'Remove',
              color: hexToColor("#FF1F6E"),
              size: 20,
              wrap: false,
            ),
            onPress: () async {
              setState(() {
                widget.dm.setToggleAlert(false);
                widget.dm.setToggleLoading(true);
              });

              final success = await firebase_DeleteDocument(
                  '${appName}_GroceryLists', listId);
              if (success) {
                setState(() {
                  widget.dm.setToggleLoading(false);
                });
              }
            })
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
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
              BorderView(
                bottom: true,
                bottomColor: Colors.white24,
                child: PaddingView(
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
                              text: 'Grocery Lists',
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
                          // NEW FLASHCARD STACK
                          nav_Push(context, GroceryNewWidget(dm: widget.dm),
                              () {
                            setState(() {});
                          });
                        })
                  ],
                )),
              ),
              //  FLASHCARD STACKS HERE
              // MAIN
              SingleChildScrollView(
                child: Column(
                  children: [
                    FutureView(
                        future: _fetchLists(),
                        childBuilder: (data) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (var list in data)
                                BorderView(
                                  bottom: true,
                                  bottomColor: Colors.white30,
                                  child: AccordionView(
                                    topWidget: PaddingView(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextView(
                                            text: list['title'],
                                            color: Colors.white,
                                            size: 22,
                                            font: 'inconsolata',
                                            weight: FontWeight.w600,
                                          ),
                                          const Icon(
                                            Icons.arrow_drop_down,
                                            size: 34,
                                            color: Colors.white70,
                                          )
                                        ],
                                      ),
                                    ),
                                    bottomWidget: PaddingView(
                                      child: Column(
                                          // Changed from Row to Column
                                          children: [
                                            ...list['items']
                                                .map<Widget>((item) {
                                              return Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  CheckboxView(
                                                    height: 28,
                                                    width: 28,
                                                    onChange: (value) {},
                                                  ),
                                                  const SizedBox(
                                                    width: 15,
                                                  ),
                                                  TextView(
                                                    text: item,
                                                    size: 22,
                                                    color: Colors.white,
                                                    font: 'inconsolata',
                                                  ),
                                                ],
                                              );
                                            }).toList(),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                ButtonView(
                                                    child: TextView(
                                                      text: 'edit',
                                                      color:
                                                          hexToColor("#3C96D3"),
                                                      size: 20,
                                                      font: 'inconsolata',
                                                    ),
                                                    onPress: () {
                                                      // GO TO EDIT
                                                      nav_Push(
                                                          context,
                                                          GroceryEditWidget(
                                                            dm: widget.dm,
                                                            list: list,
                                                          ), () {
                                                        setState(() {});
                                                      });
                                                    }),
                                                const SizedBox(
                                                  width: 15,
                                                ),
                                                ButtonView(
                                                    child: TextView(
                                                      text: 'remove',
                                                      color:
                                                          hexToColor("#FF1F6E"),
                                                      size: 20,
                                                      font: 'inconsolata',
                                                    ),
                                                    onPress: () {
                                                      // REMOVE LIST
                                                      onRemoveList(list['id']);
                                                    }),
                                              ],
                                            )
                                          ]),
                                    ),
                                  ),
                                )
                            ],
                          );
                        },
                        emptyWidget: const PaddingView(
                            child: Center(
                          child: TextView(
                            text: 'No grocery lists yet.',
                          ),
                        ))),
//
                    const SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
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
