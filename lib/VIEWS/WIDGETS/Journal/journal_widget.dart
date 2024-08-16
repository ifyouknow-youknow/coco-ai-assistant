import 'package:coco_ai_assistant/COMPONENTS/border_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/button_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/future_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/padding_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/text_view.dart';
import 'package:coco_ai_assistant/FUNCTIONS/array.dart';
import 'package:coco_ai_assistant/FUNCTIONS/colors.dart';
import 'package:coco_ai_assistant/FUNCTIONS/nav.dart';
import 'package:coco_ai_assistant/MASTER/datamaster.dart';
import 'package:coco_ai_assistant/MODELS/screen.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/Journal/journal_full_widget.dart';
import 'package:flutter/material.dart';

class JournalWiget extends StatefulWidget {
  DataMaster dm;
  JournalWiget({super.key, required this.dm});

  @override
  State<JournalWiget> createState() => _JournalWigetState();
}

class _JournalWigetState extends State<JournalWiget> {
  Future<dynamic> _fetchEntries() async {
    return await widget.dm.getJournalEntries();
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
                    widget.dm.setToggleJournalEntriesWidget(
                        !widget.dm.toggleJournalEntriesWidget);
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.description_outlined,
                          color: Colors.white70,
                          size: 22,
                        ),
                        SizedBox(
                          width: 6,
                        ),
                        TextView(
                          text: 'Journal Entries',
                          color: Colors.white,
                          size: 22,
                          font: 'inconsolata',
                          weight: FontWeight.w600,
                        ),
                      ],
                    ),
                    ButtonView(
                        child: Icon(
                          widget.dm.toggleJournalEntriesWidget
                              ? Icons.arrow_drop_up
                              : Icons.arrow_drop_down,
                          size: 38,
                          color: Colors.white60,
                        ),
                        onPress: () {
                          // REFRESH
                          setState(() {
                            widget.dm.setToggleJournalEntriesWidget(true);
                          });
                        })
                  ],
                ),
              ),
            ),
            if (widget.dm.toggleJournalEntriesWidget)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 6,
                  ),
                  TextView(
                    text: 'Recent',
                    color: hexToColor("#8EB8ED"),
                    size: 22,
                    weight: FontWeight.w600,
                    font: 'inconsolata',
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  // ENTRIES
                  FutureView(
                    future: _fetchEntries(),
                    childBuilder: (data) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var entry in data.take(3))
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextView(
                                  text: entry['title'],
                                  color: Colors.white,
                                  size: 22,
                                  weight: FontWeight.w600,
                                  font: 'inconsolata',
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                TextView(
                                  text: entry['summary'],
                                  color: Colors.white,
                                  size: 18,
                                  font: 'inconsolata',
                                ),
                                const SizedBox(
                                  height: 20,
                                )
                              ],
                            )
                        ],
                      );
                    },
                    emptyWidget: const PaddingView(
                      child: Center(
                        child: TextView(
                          text: 'No journal entries found.',
                          size: 20,
                          color: Colors.white,
                          font: 'inconsolata',
                        ),
                      ),
                    ),
                  ),
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
                            nav_Push(context, JournalFullWidget(dm: widget.dm),
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
