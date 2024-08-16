import 'package:coco_ai_assistant/COMPONENTS/border_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/button_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/checkbox_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/future_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/padding_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/text_view.dart';
import 'package:coco_ai_assistant/FUNCTIONS/array.dart';
import 'package:coco_ai_assistant/FUNCTIONS/colors.dart';
import 'package:coco_ai_assistant/FUNCTIONS/nav.dart';
import 'package:coco_ai_assistant/MASTER/datamaster.dart';
import 'package:coco_ai_assistant/MODELS/constants.dart';
import 'package:coco_ai_assistant/MODELS/firebase.dart';
import 'package:coco_ai_assistant/MODELS/screen.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/Notes/notes_full_widget.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/Tasks/tasks_full_widget.dart';
import 'package:flutter/material.dart';

class NotesWidget extends StatefulWidget {
  DataMaster dm;
  NotesWidget({super.key, required this.dm});

  @override
  State<NotesWidget> createState() => _NotesWidgetState();
}

class _NotesWidgetState extends State<NotesWidget> {
  Future<List<dynamic>> _fetchNotes() async {
    return await widget.dm.getNotes();
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
                        .setToggleNotesWidget(!widget.dm.toggleNotesWidget);
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.draw_outlined,
                          color: Colors.white70,
                          size: 22,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        TextView(
                          text: 'Notes',
                          color: Colors.white,
                          size: 22,
                          font: 'inconsolata',
                          weight: FontWeight.w600,
                        ),
                      ],
                    ),
                    ButtonView(
                        child: Icon(
                          widget.dm.toggleNotesWidget
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                          size: 38,
                          color: Colors.white60,
                        ),
                        onPress: () async {
                          setState(() {
                            widget.dm.setToggleNotesWidget(true);
                          });
                        })
                  ],
                ),
              ),
            ),

            // NOTES
            if (widget.dm.toggleNotesWidget)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 6,
                  ),
                  TextView(
                    text: 'Recents',
                    color: hexToColor("#8EB8ED"),
                    size: 22,
                    font: 'inconsolata',
                    weight: FontWeight.w600,
                  ),
                  FutureView(
                      future: _fetchNotes(),
                      childBuilder: (data) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (var note
                                in sortArrayByProperty(data, 'date', desc: true)
                                    .take(4))
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextView(
                                    text: note['title'],
                                    color: Colors.white,
                                    size: 22,
                                    font: 'inconsolata',
                                    weight: FontWeight.w600,
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  TextView(
                                    text: note['summary'],
                                    color: Colors.white,
                                    size: 18,
                                    font: 'inconsolata',
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  )
                                ],
                              )
                          ],
                        );
                      },
                      emptyWidget: const PaddingView(
                        child: Center(
                          child: TextView(
                            text: 'No notes found.',
                            size: 20,
                            color: Colors.white,
                            font: 'inconsolata',
                          ),
                        ),
                      )),
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
                              context,
                              NotesFullWidget(
                                dm: widget.dm,
                              ), () {
                            setState(() {});
                          });
                        },
                      ),
                    ],
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
