import 'package:coco_ai_assistant/COMPONENTS/border_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/button_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/checkbox_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/future_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/padding_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/roundedcorners_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/text_view.dart';
import 'package:coco_ai_assistant/FUNCTIONS/array.dart';
import 'package:coco_ai_assistant/FUNCTIONS/colors.dart';
import 'package:coco_ai_assistant/FUNCTIONS/date.dart';
import 'package:coco_ai_assistant/FUNCTIONS/misc.dart';
import 'package:coco_ai_assistant/FUNCTIONS/nav.dart';
import 'package:coco_ai_assistant/MASTER/datamaster.dart';
import 'package:coco_ai_assistant/MODELS/constants.dart';
import 'package:coco_ai_assistant/MODELS/firebase.dart';
import 'package:coco_ai_assistant/MODELS/screen.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/Grocery/grocery_full_widget.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/Tasks/tasks_full_widget.dart';
import 'package:flutter/material.dart';

class GroceryWidget extends StatefulWidget {
  DataMaster dm;
  GroceryWidget({super.key, required this.dm});

  @override
  State<GroceryWidget> createState() => _GroceryWidgetState();
}

class _GroceryWidgetState extends State<GroceryWidget> {
  Future<dynamic> _fetchLists() async {
    final listDocs = await widget.dm.getGroceryLists();
    return listDocs;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: getWidth(context),
      child: PaddingView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              child: ButtonView(
                onPress: () {
                  setState(() {
                    widget.dm
                        .setToggleGroceryWidget(!widget.dm.toggleGroceryWidget);
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.local_grocery_store_outlined,
                          color: Colors.white70,
                          size: 22,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        TextView(
                          text: 'Grocery Lists',
                          color: Colors.white,
                          size: 22,
                          font: 'inconsolata',
                          weight: FontWeight.w600,
                        ),
                      ],
                    ),
                    ButtonView(
                        child: Icon(
                          widget.dm.toggleGroceryWidget
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                          size: 38,
                          color: Colors.white60,
                        ),
                        onPress: () async {
                          setState(() {
                            widget.dm.setToggleGroceryWidget(true);
                          });
                        })
                  ],
                ),
              ),
            ),
            // MAIN
            if (widget.dm.toggleGroceryWidget)
              FutureView(
                  future: _fetchLists(),
                  childBuilder: (data) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextView(
                          text: 'Recents',
                          color: hexToColor("#8EB8ED"),
                          size: 22,
                          font: 'inconsolata',
                        ),
                        for (var list
                            in sortArrayByProperty(data, 'title').take(6))
                          PaddingView(
                            paddingTop: 0,
                            paddingBottom: 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextView(
                                  text: list['title'],
                                  color: Colors.white,
                                  size: 22,
                                  font: 'inconsolata',
                                  weight: FontWeight.w600,
                                ),
                              ],
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

            // TASKS
            if (widget.dm.toggleGroceryWidget)
              Column(
                children: [
                  const SizedBox(
                    height: 6,
                  ),
                  // EVERYTHING HERE

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
                            nav_Push(context, GroceryFullWidget(dm: widget.dm),
                                () {
                              setState(() {});
                            });
                          })
                    ],
                  )
                ],
              )
          ],
        ),
      ),
    );
  }
}
