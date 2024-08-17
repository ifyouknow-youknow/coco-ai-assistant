import 'package:coco_ai_assistant/FUNCTIONS/array.dart';
import 'package:coco_ai_assistant/FUNCTIONS/date.dart';
import 'package:coco_ai_assistant/MODELS/constants.dart';
import 'package:coco_ai_assistant/MODELS/firebase.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class DataMaster {
  // FIELDS
  late String _userId;

  // COLORS
  String backgroundColor = '#000000';

  //STRINGS
  String _priority = "LOW";
  String _alertTitle = "";
  String _alertText = "";

  // TOGGLES
  bool _toggleLoading = false;
  bool _toggleShowOptions = false;
  bool _toggleShowType = false;
  bool _toggleAlert = false;
  bool _toggleEditTask = false;
  //
  bool _toggleTasksWidget = false;
  bool _toggleJournalEntriesWidget = false;
  bool _toggleNotesWidget = false;
  bool _toggleFlashcardsWidget = false;
  bool _toggleGroceryWidget = false;

  // CONTROLLERS
  late TextEditingController _chatTextController;
  late TextEditingController _taskTextController;
  late TextEditingController _categoryTextController;
  late TextEditingController _dateTextController;
  late TextEditingController _entryTextController;
  late TextEditingController _titleTextController;
  late TextEditingController _noteTextController;
  late TextEditingController _folderTextController;
  late TextEditingController _itemsController;
  late TextEditingController _frontController;
  late TextEditingController _backController;

// LISTS
  List<Map<String, dynamic>> _responses = [];
  List<dynamic> _tasks = [];
  List<dynamic> _journalEntries = [];
  List<dynamic> _notes = [];
  List<dynamic> _flashcards = [];
  List<Widget> _alertButtons = [];
  List<String> _folders = [];

// MISC
  late ChatSession _chat;

  // ---------------------------

  // CONSTRUCTOR
  DataMaster();

  // GETTERS
  // BOOL
  bool get toggleLoading => _toggleLoading;
  bool get toggleShowOptions => _toggleShowOptions;
  bool get toggleShowType => _toggleShowType;
  bool get toggleAlert => _toggleAlert;
  bool get toggleEditTask => _toggleEditTask;
  //
  bool get toggleTasksWidget => _toggleTasksWidget;
  bool get toggleJournalEntriesWidget => _toggleJournalEntriesWidget;
  bool get toggleNotesWidget => _toggleNotesWidget;
  bool get toggleFlashcardsWidget => _toggleFlashcardsWidget;
  bool get toggleGroceryWidget => _toggleGroceryWidget;

  // STRINGS
  String get userId => _userId;
  String get priority => _priority;
  String get alertTitle => _alertTitle;
  String get alertText => _alertText;

  // LISTS
  List<Map<String, dynamic>> get responses => _responses;
  List<dynamic> get tasks => _tasks;
  List<dynamic> get journalEntries => _journalEntries;
  List<dynamic> get notes => _notes;
  List<dynamic> get flashcards => _flashcards;
  List<Widget> get alertButtons => _alertButtons;
  List<String> get folders => _folders;

  // CONTROLLERS
  TextEditingController get chatTextController => _chatTextController;
  TextEditingController get taskTextController => _taskTextController;
  TextEditingController get categoryTextController => _categoryTextController;
  TextEditingController get dateTextController => _dateTextController;
  TextEditingController get titleTextController => _titleTextController;
  TextEditingController get entryTextController => _entryTextController;
  TextEditingController get noteTextController => _noteTextController;
  TextEditingController get folderTextController => _folderTextController;
  TextEditingController get itemsController => _itemsController;
  TextEditingController get frontController => _frontController;
  TextEditingController get backController => _backController;

  // MISC
  ChatSession get chat => _chat;

  // MAPS

  // SETTERS
  void setUserId(String value) => _userId = value;
  void setToggleLoading(bool value) => _toggleLoading = value;
  void setToggleShowOptions(bool value) => _toggleShowOptions = value;
  void setToggleShowType(bool value) => _toggleShowType = value;
  void setToggleAlert(bool value) => _toggleAlert = value;
  void setToggleEditTask(bool value) => _toggleEditTask = value;
  //
  void setToggleTasksWidget(bool value) => _toggleTasksWidget = value;
  void setToggleJournalEntriesWidget(bool value) =>
      _toggleJournalEntriesWidget = value;
  void setToggleNotesWidget(bool value) => _toggleNotesWidget = value;
  void setToggleFlashcardsWidget(bool value) => _toggleFlashcardsWidget = value;
  void setToggleGroceryWidget(bool value) => _toggleGroceryWidget = value;
  //
  void setChat(ChatSession value) => _chat = value;
  void setPriority(String value) => _priority = value;
  void setAlertTitle(String value) => _alertTitle = value;
  void setAlertText(String value) => _alertText = value;
  //
  void setResponses(List<Map<String, dynamic>> value) => _responses = value;
  void addToResponses(dynamic value) {
    _responses.add(value);
  }

  void setTasks(List<dynamic> value) => _tasks = value;
  void addToTasks(dynamic value) {
    _tasks.add(value);
  }

  void setJournalEntries(List<dynamic> value) => _journalEntries = value;
  void addToJournalEntries(dynamic value) {
    _journalEntries.add(value);
  }

  void setNotes(List<dynamic> value) => _notes = value;
  void addToNotes(dynamic value) {
    _notes.add(value);
  }

  void setFolders(List<String> value) => _folders = value;
  void setFlashcards(List<dynamic> value) => _flashcards = value;

  void setAlertButtons(List<Widget> value) => _alertButtons = value;

  // INITS
  void init_chatTextController() =>
      _chatTextController = TextEditingController();
  void init_taskTextController() =>
      _taskTextController = TextEditingController();
  void init_categoryTextController() =>
      _categoryTextController = TextEditingController();
  void init_dateTextController() =>
      _dateTextController = TextEditingController();
  void init_titleTextController() =>
      _titleTextController = TextEditingController();
  void init_entryTextController() =>
      _entryTextController = TextEditingController();
  void init_noteTextController() =>
      _noteTextController = TextEditingController();
  void init_folderTextController() =>
      _folderTextController = TextEditingController();
  void init_itemsController() => _itemsController = TextEditingController();
  void init_frontController() => _frontController = TextEditingController();
  void init_backController() => _backController = TextEditingController();

  // DISPOSE
  void disposeAll() {
    _chatTextController.dispose();
    _taskTextController.dispose();
    _categoryTextController.dispose();
    _dateTextController.dispose();
    _titleTextController.dispose();
    _entryTextController.dispose();
    _noteTextController.dispose();
    _folderTextController.dispose();
    _itemsController.dispose();
    _frontController.dispose();
    _backController.dispose();
  }

  // FUNCTIONS
  Future<List<dynamic>> getTasks(DateTime date) async {
    final startDate = startOfDay(date).millisecondsSinceEpoch;
    final endDate = endOfDay(date).millisecondsSinceEpoch;
    final taskDocs = await firebase_GetAllDocumentsQueried('${appName}_Tasks', [
      {'field': 'userId', 'operator': '==', 'value': userId},
      {'field': 'date', 'operator': '>=', 'value': startDate},
      {'field': 'date', 'operator': '<=', 'value': endDate},
    ]);

    if (taskDocs.isNotEmpty) {
      final newList = taskDocs.map((ting) {
        return {
          ...ting,
          'date': DateTime.fromMillisecondsSinceEpoch(ting['date'])
              .toUtc()
              .toIso8601String()
        };
      }).toList();

      return newList;
    } else {
      return [];
    }
  }

  Future<List<dynamic>> removeTask(Map<String, dynamic> task) async {
    final success =
        await firebase_DeleteDocument('${appName}_Tasks', task['id']);
    if (success) {
      return removeObjById(_tasks.cast<Map<String, dynamic>>(), task['id']);
    } else {
      return [];
    }
  }

  Future<List<dynamic>> getJournalEntries() async {
    final journalDocs =
        await firebase_GetAllDocumentsQueried('${appName}_JournalEntries', [
      {'field': 'userId', 'operator': '==', 'value': userId}
    ]);
    if (journalDocs.isNotEmpty) {
      final newList = journalDocs.map((ting) {
        return {
          ...ting,
          'date': DateTime.fromMillisecondsSinceEpoch(ting['date'])
              .toUtc()
              .toIso8601String()
        };
      }).toList();

      return newList;
    } else {
      return [];
    }
  }

  Future<List<dynamic>> getNotes() async {
    final docs = await firebase_GetAllDocumentsQueried('${appName}_Notes', [
      {'field': 'userId', 'operator': '==', 'value': userId},
    ]);
    if (docs.isNotEmpty) {
      // REPLACE THIS
      return docs;
    } else {
      return [];
    }
  }

  Future<List<dynamic>> getFlashcards() async {
    final docs =
        await firebase_GetAllDocumentsQueried('${appName}_Flashcards', [
      {'field': 'userId', 'operator': '==', 'value': userId},
    ]);
    if (docs.isNotEmpty) {
      // REPLACE THIS
      return docs;
    } else {
      return [];
    }
  }

  Future<List<dynamic>> getGroceryLists() async {
    final docs =
        await firebase_GetAllDocumentsQueried('${appName}_GroceryLists', [
      {'field': 'userId', 'operator': '==', 'value': userId},
    ]);
    if (docs.isNotEmpty) {
      // REPLACE THIS
      return docs;
    } else {
      return [];
    }
  }
}
