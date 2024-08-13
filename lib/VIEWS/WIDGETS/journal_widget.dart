import 'package:coco_ai_assistant/COMPONENTS/border_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/button_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/padding_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/text_view.dart';
import 'package:coco_ai_assistant/FUNCTIONS/array.dart';
import 'package:coco_ai_assistant/FUNCTIONS/colors.dart';
import 'package:coco_ai_assistant/FUNCTIONS/nav.dart';
import 'package:coco_ai_assistant/MASTER/datamaster.dart';
import 'package:coco_ai_assistant/MODELS/screen.dart';
import 'package:coco_ai_assistant/VIEWS/WIDGETS/journal_full_widget.dart';
import 'package:flutter/material.dart';

class JournalWiget extends StatefulWidget {
  DataMaster dm;
  JournalWiget({super.key, required this.dm});

  @override
  State<JournalWiget> createState() => _JournalWigetState();
}

class _JournalWigetState extends State<JournalWiget> {
  void init() async {
    final tempJournalEntries = await widget.dm.getJournalEntries();
    setState(() {
      widget.dm.setJournalEntries(tempJournalEntries);
    });
  }

  @override
  Widget build(BuildContext context) {
    init();
    return SizedBox(
      width: getWidth(context),
      child: BorderView(
        top: true,
        topColor: Colors.white10,
        bottom: true,
        bottomColor: Colors.white10,
        child: PaddingView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: ButtonView(
                  onPress: () {
                    widget.dm.setToggleJournalEntriesWidget(
                        !widget.dm.toggleJournalEntriesWidget);
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
                    // ENTRIES
                    ...sortArrayByProperty(
                            widget.dm.journalEntries
                                .cast<Map<String, dynamic>>(),
                            'date',
                            desc: true)
                        .take(3)
                        .map((entry) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextView(
                            text: entry['title'],
                            size: 22,
                            color: hexToColor("#8EB8ED"),
                            font: 'inconsolata',
                            weight: FontWeight.w600,
                          ),
                          TextView(
                            text: entry['summary'],
                            size: 18,
                            color: Colors.white,
                            font: 'inconsolata',
                          ),
                          const SizedBox(
                            height: 8,
                          )
                        ],
                      );
                    }),

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
                                  context, JournalFullWidget(dm: widget.dm));
                            })
                      ],
                    )
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
