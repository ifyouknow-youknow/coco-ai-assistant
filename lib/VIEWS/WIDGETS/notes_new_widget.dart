import 'package:coco_ai_assistant/COMPONENTS/alert_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/border_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/button_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/dropdown_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/loading_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/padding_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/text_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/textfield_view.dart';
import 'package:coco_ai_assistant/FUNCTIONS/array.dart';
import 'package:coco_ai_assistant/FUNCTIONS/colors.dart';
import 'package:coco_ai_assistant/FUNCTIONS/nav.dart';
import 'package:coco_ai_assistant/MASTER/datamaster.dart';
import 'package:coco_ai_assistant/MODELS/JOBS/coco_jobs.dart';
import 'package:coco_ai_assistant/MODELS/coco.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class NotesNewWidget extends StatefulWidget {
  DataMaster dm;
  NotesNewWidget({super.key, required this.dm});

  @override
  State<NotesNewWidget> createState() => _NotesNewWidgetState();
}

class _NotesNewWidgetState extends State<NotesNewWidget> {
  List<String> _folders = [];

  void init() async {
    final tempNotes = await widget.dm.getNotes();
    widget.dm.setFolders([]);
    List<String> folders =
        tempNotes.map((ting) => ting['folder']).toList().cast<String>();
    if (folders.isNotEmpty) {
      setState(() {
        widget.dm.folderTextController.text = folders[0];
        _folders = removeDupes(folders).cast<String>();
      });
    }
  }

  @override
  void initState() {
    init();
    widget.dm.init_titleTextController();
    widget.dm.init_noteTextController();
    widget.dm.init_folderTextController();
    super.initState();
  }

  @override
  void dispose() {
    widget.dm.dispose_titleTextController();
    widget.dm.dispose_noteTextController();
    widget.dm.dispose_folderTextController();
    super.dispose();
  }

  void onCreateNote() async {
    final _title = widget.dm.titleTextController.text;
    final _note = widget.dm.noteTextController.text;
    final _folder = widget.dm.folderTextController.text;

    if (_title.isEmpty || _note.isEmpty || _folder.isEmpty) {
      setState(() {
        widget.dm.setAlertTitle('Missing Info');
        widget.dm.setAlertText('Please provide all parts to create this task.');
        widget.dm.setToggleAlert(true);
      });
      return;
    }

    setState(() {
      widget.dm.setToggleLoading(true);
    });
    final chat = await coco_StartCustomChat(
        'UserId: ${widget.dm.userId}. You are a notes manager. Your job is to create a note based on user input.',
        declarationList);

    final response = await coco_SendChat(
        chat,
        'Create a note for me: Title: $_title. Note: $_note. Folder: $_folder. Make sure to create a summary based on this information.',
        functionMap);

    setState(() {
      widget.dm.setToggleLoading(false);
      widget.dm.getNotes();
    });

    nav_Pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexToColor("#0D1116"),
      body: Stack(
        children: [
          Container(
            color: hexToColor("#12161D"),
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
                        text: 'new note',
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
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SingleChildScrollView(
                          child: Column(
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
                                  maxLines: 5,
                                  placeholder: 'ex. an entrance to the bagel.',
                                ),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              const TextView(
                                text: 'folder',
                                color: Colors.white,
                                size: 18,
                                font: 'inconsolata',
                                weight: FontWeight.w700,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: BorderView(
                                      bottom: true,
                                      bottomColor: Colors.white,
                                      bottomWidth: 1,
                                      child: TextfieldView(
                                        controller:
                                            widget.dm.folderTextController,
                                        backgroundColor: Colors.transparent,
                                        color: Colors.white,
                                        placeholderColor: Colors.white60,
                                        size: 20,
                                        maxLines: 5,
                                        placeholder: 'name of the folder',
                                      ),
                                    ),
                                  ),
                                  if (_folders.isNotEmpty)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const TextView(
                                          text: 'folders',
                                          color: Colors.white,
                                          size: 18,
                                          font: 'inconsolata',
                                          weight: FontWeight.w700,
                                        ),
                                        DropdownView(
                                          backgroundColor:
                                              hexToColor("#12161D"),
                                          items: _folders,
                                          onChanged: (value) {
                                            setState(() {
                                              widget.dm.folderTextController
                                                  .text = value;
                                            });
                                          },
                                          textColor: Colors.white,
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              // CATEGORY
                              const TextView(
                                text: 'note',
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
                                  controller: widget.dm.noteTextController,
                                  backgroundColor: Colors.transparent,
                                  color: Colors.white,
                                  placeholderColor: Colors.white60,
                                  size: 20,
                                  maxLines: 20,
                                  placeholder: 'type your note here..',
                                  multiline: true,
                                ),
                              ),
                            ],
                          ),
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
                                      onCreateNote();
                                    })
                              ],
                            ),
                            const SizedBox(
                              height: 35,
                            )
                          ],
                        )
                      ],
                    ),
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
