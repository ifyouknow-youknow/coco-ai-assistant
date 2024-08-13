import 'dart:convert';
import 'package:coco_ai_assistant/FUNCTIONS/misc.dart';
import 'package:coco_ai_assistant/MODELS/coco.dart';
import 'package:coco_ai_assistant/MODELS/constants.dart';
import 'package:coco_ai_assistant/MODELS/firebase.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

const tasksInstructions =
    'You are a task manager. This job involves creating new tasks, updating tasks, removing tasks, and sharing tasks with other users. Use the provided functions to interact with the main database which stores all of the task data. The user may select another job if they need help with something else.';
const journalInstructions =
    'You are a journal manager. Your job is to assist the user in creating, editing, removing journal entries. The user may select another job if they need help with something else.';

// DECLARATIONS
// TASKS
final declarationCreateTask = FunctionDeclaration(
  'createTask',
  'Creates a new task record in the database. Remember this information. Use this it the user has requested to create a new task and not update.',
  Schema(
    SchemaType.object,
    properties: {
      'userId': Schema(SchemaType.string, description: 'The id of the user.'),
      'task': Schema(SchemaType.string,
          description:
              'The task in tet form. This should be generalized and based on what the user says.'),
      'category': Schema(SchemaType.string,
          description:
              'The category that the task belongs in. Do not use category names that are too unique so you can put multiple tasks in a category if they fit such as Work, Personal, etc.'),
      'date': Schema(SchemaType.string,
          description:
              'Whatever date they say, but in this format: “2024-08-05T12:34:56Z”. If they do not provide a date, assume it is for today.'),
      'priority': Schema(SchemaType.string,
          description: 'The priority of this task. Set to LOW as default.'),
      'status': Schema(SchemaType.string,
          description: 'Set this status initially to IN PROCESS.'),
    },
    requiredProperties: [
      'userId',
      'task',
      'category',
      'date',
      'priority',
      'status'
    ],
  ),
);
final declarationUpdateTask = FunctionDeclaration(
  'updateTask',
  'Update or change an existing task a new task record from the database. Use the original id of the task. Do not ask for the id, you will be provided the ids. Only call if the user wants to update and not create a task. If you do not have any tasks in your history, call the getTasks function first.',
  Schema(
    SchemaType.object,
    properties: {
      'id': Schema(SchemaType.string,
          description:
              'Do not update this. Use the same id that was provided for this task. The original id for the specific task the user wants to update.'),
      'userId': Schema(SchemaType.string, description: 'The id of the user.'),
      'task': Schema(SchemaType.string,
          description:
              'The task in tet form. This should be generalized and based on what the user says.'),
      'category':
          Schema(SchemaType.string, description: 'The category that the task.'),
      'date': Schema(SchemaType.string,
          description:
              'The date this task is meant to be completed on. If no date is specified, set today as the date. Make sure it is in this format: “2024-08-05T12:34:56Z”.'),
      'priority': Schema(SchemaType.string,
          description: 'The priority of this task. Set to LOW as default.'),
      'status': Schema(SchemaType.string,
          description:
              'The current status of this task, unless the user wants to update this to COMPLETE.'),
    },
    requiredProperties: [
      'id',
      'userId',
      'task',
      'category',
      'date',
      'priority',
      'status'
    ],
  ),
);
final declarationGetTasks = FunctionDeclaration(
  'getTasks',
  'Get all tasks for the specified day. Always call this function if you do not know any tasks the user has.',
  Schema(
    SchemaType.object,
    properties: {
      'userId': Schema(SchemaType.string, description: 'The id of the user.'),
      'date': Schema(SchemaType.string,
          description:
              'The date the user wants to get tasks for. If no date is specified, assume it is for today ${DateTime.now()}. Make sure you return in this format: "YYYY-MM-DDTHH:MM:SSZ"'),
    },
    requiredProperties: ['userId', 'date'],
  ),
);
// JOURNAL ENTRIES
final declarationCreateJournalEntry = FunctionDeclaration(
  'createJournalEntry',
  'Creates a new journal entry, saves the entry, and a summary of the entry for easy look up. Make sure you have all pieces except for the date and summary before calling this function. Do not ask for the date. Do not give suggestions, let the user decide what the title and entry is on their own.',
  Schema(
    SchemaType.object,
    properties: {
      'userId': Schema(SchemaType.string, description: 'The id of the user.'),
      'title': Schema(SchemaType.string,
          description:
              'The title of the journal entry. Correct any mispellings, but leave the rest the same.'),
      'entry': Schema(SchemaType.string,
          description:
              'The entire journal entry provided by the user. Correct any mispellings, but leave everything else the same.'),
      'summary': Schema(SchemaType.string,
          description:
              'The entire journal entry summarized in one sentence max. You will create this, NOT the user. Do not ask for the summary.'),
    },
    requiredProperties: [
      'userId',
      'title',
      'entry',
      'summary',
    ],
  ),
);
final declarationGetAllJournalEntries = FunctionDeclaration(
  'getAllJournalEntries',
  'Gets all journal entries. If the user is requesting to see their entries, call this function first.',
  Schema(
    SchemaType.object,
    properties: {
      'userId': Schema(SchemaType.string, description: 'The id of the user.'),
    },
    requiredProperties: [
      'userId',
    ],
  ),
);
// NOTES
final declarationCreateNote = FunctionDeclaration(
  'createNote',
  'Creates a note using the information provided by the user.',
  Schema(
    SchemaType.object,
    properties: {
      'userId': Schema(SchemaType.string, description: 'The id of the user.'),
      'folder': Schema(SchemaType.string,
          description: 'The name of the folder this note belongs in.'),
      'title':
          Schema(SchemaType.string, description: 'The title of this note.'),
      'note': Schema(SchemaType.string,
          description:
              'All note content provided by the user in its exact form. Only do simple spell check, nothing else.'),
      'summary': Schema(SchemaType.string,
          description:
              'Do not ask the user to provide a summary. You need to create the summary based on the title and the note itself. One sentence.'),
    },
    requiredProperties: ['userId', 'folder', 'title', 'note', 'summary'],
  ),
);
final declarationGetAllNotes = FunctionDeclaration(
  'getAllNotes',
  'Gets all notes belonging to the user.',
  Schema(
    SchemaType.object,
    properties: {
      'userId': Schema(SchemaType.string, description: 'The id of the user.'),
    },
    requiredProperties: [
      'userId',
    ],
  ),
);
// FLASHCARDS
final declarationCreateFlashcards = FunctionDeclaration(
  'createFlashcards',
  'Create a stack of flashcards. You will need to collect all cards before calling this function. Ask the user to submit all front and back values in this format: \nfront:back, front:back, etc. Before calling this function, confirm that all values are correct. Update any that need to be corrected including the stack name. Once confirmed, call this function. Ask them to provide all card values at once separated with a comma.',
  Schema(
    SchemaType.object,
    properties: {
      'userId': Schema(SchemaType.string, description: 'The id of the user.'),
      'stackName': Schema(SchemaType.string,
          description: 'The name of this stack of flashcards.'),
      'flashcards': Schema(
        SchemaType.array,
        description:
            'All flashcard pairs in the form of an array of map. {"front": "value", "back": "value}',
        items: Schema(
          SchemaType.object,
          properties: {
            'front': Schema(SchemaType.string,
                description: 'The front side of the flashcard.'),
            'back': Schema(SchemaType.string,
                description: 'The back side of the flashcard.'),
          },
          requiredProperties: ['front', 'back'],
        ),
      ),
    },
    requiredProperties: ['userId', "stackName", "flashcards"],
  ),
);
final declarationGetAllFlashcards = FunctionDeclaration(
  'getAllFlashcards',
  'Gets all flashcards belonging to the user.',
  Schema(
    SchemaType.object,
    properties: {
      'userId': Schema(SchemaType.string, description: 'The id of the user.'),
    },
    requiredProperties: [
      'userId',
    ],
  ),
);

//

List<FunctionDeclaration> declarationList = [
  declarationCreateTask,
  declarationUpdateTask,
  declarationGetTasks,
  declarationCreateJournalEntry,
  declarationGetAllJournalEntries,
  declarationCreateNote,
  declarationGetAllNotes,
  declarationCreateFlashcards,
  declarationGetAllFlashcards
];

//
// FUNCTIONS
final functionMap = {
  'createTask': onCreateTask,
  'updateTask': onUpdateTask,
  'getTasks': onGetTasks,
  'createJournalEntry': onCreateJournalEntry,
  'getAllJournalEntries': onGetAllJournalEntries,
  'createNote': onCreateNote,
  'getAllNotes': onGetAllNotes,
  'createFlashcards': onCreateFlashcards,
  'getAllFlashcards': onGetAllFlashcards
};

// TASKS
Future<String> onCreateTask(args, chat) async {
  print("CREATE TASK");
  final utcDateTime = DateTime.parse(args['date']).toUtc();
  final epochDate = utcDateTime.millisecondsSinceEpoch;
  Map<String, dynamic> newArgs = {...args, 'date': epochDate};
  print(newArgs);

  final id = randomString(25);
  final success =
      await firebase_CreateDocument('${appName}_Tasks', id, newArgs);

  if (success) {
    final response = await coco_SendChat(
        chat,
        'The task was created and stored in the database with an id of $id. Do not tell the user the id, but remember it for future reference. Let the user know that the task was created and ask what else you can do for them.',
        functionMap);
    return response!;
  } else {
    return 'Something went wrong. The task was not created.';
  }
}

Future<String> onUpdateTask(args, chat) async {
  print("UPDATE TASK");
  final utcDateTime = DateTime.parse(args['date']).toUtc();
  final epochDate = utcDateTime.millisecondsSinceEpoch;
  Map<String, dynamic> newArgs = {...args, 'date': epochDate};
  print(newArgs);
  final success =
      await firebase_UpdateDocument('${appName}_Tasks', args['id'], newArgs);
  if (success) {
    final response = await coco_SendChat(
        chat,
        'The task was updated and stored in the database. Do not tell the user the id, but remember it for future reference. Let the user know that the task was updated and ask what else you can do for them.',
        functionMap);
    return response!;
  } else {
    return 'Something went wrong. The task was not updated.';
  }
}

Future<String> onGetTasks(args, chat) async {
  print("GET TASKS");
  final userId = args['userId'];
  final dateStr = args['date'];
  final epochDate = DateTime.parse(dateStr).toUtc();
  final startDate = DateTime.utc(epochDate.year, epochDate.month, epochDate.day)
      .millisecondsSinceEpoch;

  final taskDocs = await firebase_GetAllDocumentsQueried('${appName}_Tasks', [
    {'field': 'userId', 'operator': '==', 'value': userId},
    {'field': 'date', 'operator': '>=', 'value': startDate},
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
    print(newList);
    final response = await coco_SendChat(
        chat,
        'Turn this JSON into a readable text list format. You do not need to include the id or the userId, but remember it in case you need to update a task. JSON: ${jsonEncode(newList)}. Only tell me the ones specified for this day. Put them in this format: (category): \n - status (either IN PROCESS or COMPLETE) (priority) -> list of task names. Filter them by priority with high being at the top.',
        functionMap);
    // ADD TO CHAT HISTORY
    print(response);
    return response!;
  } else {
    return 'It seems you do not have any tasks for this day.';
  }
}

// JOURNAL ENTRIES
Future<String> onCreateJournalEntry(args, chat) async {
  print("CREATE JOURNAL ENTRY");
  final utcDateTime = DateTime.now().toUtc();
  final epochDate = utcDateTime.millisecondsSinceEpoch;
  Map<String, dynamic> newArgs = {...args, 'date': epochDate};
  print(newArgs);

  final id = randomString(25);
  final success =
      await firebase_CreateDocument('${appName}_JournalEntries', id, newArgs);

  if (success) {
    final response = await coco_SendChat(
        chat,
        'The journal entry was created and stored in the database with an id of $id. Do not tell the user the id, but remember it for future reference. Let the user know that the journal entry was created and ask what else you can do for them.',
        functionMap);
    return response!;
  } else {
    return 'Something went wrong. The journal entry was not created.';
  }
}

Future<String> onGetAllJournalEntries(args, chat) async {
  print('THESE ARE THE ARGS');
  print(args);
  final journalDocs =
      await firebase_GetAllDocumentsQueried('${appName}_JournalEntries', [
    {'field': 'userId', 'operator': '==', 'value': args['userId']}
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
    final response = await coco_SendChat(
        chat,
        'This user has created the following journal entries: ${jsonEncode(newList)}. Provide a list of the titles - summary and then share all journal entry details then the user requests a specific one.',
        functionMap);
    return response!;
  } else {
    return 'You currently do not have any journal entries.';
  }
}

// NOTES
Future<String> onCreateNote(args, chat) async {
  print("CREATE NOTE");
  print(args);
  final utcDateTime = DateTime.now().toUtc();
  final epochDate = utcDateTime.millisecondsSinceEpoch;
  Map<String, dynamic> newArgs = {...args, 'date': epochDate};
  print(newArgs);

  final id = randomString(25);
  final success =
      await firebase_CreateDocument('${appName}_Notes', id, newArgs);

  if (success) {
    final response = await coco_SendChat(
        chat,
        'The note was created and stored in the database with an id of $id. Do not tell the user the id, but remember it for future reference. Let the user know that the note was created and ask what else you can do for them.',
        functionMap);
    return response!;
  } else {
    return 'Something went wrong. The note was not created.';
  }
}

Future<String> onGetAllNotes(args, chat) async {
  print("GET NOTES");
  final userId = args['userId'];

  final taskDocs = await firebase_GetAllDocumentsQueried('${appName}_Notes', [
    {'field': 'userId', 'operator': '==', 'value': userId},
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
    print(newList);
    final response = await coco_SendChat(
        chat,
        'Turn this JSON into a readable text list format. You do not need to include the id or the userId, but remember it in case you need to update the note. JSON: ${jsonEncode(newList)}.Put them in this format: (folder): \n - title \n summary. Filter them by priority with high being at the top.',
        functionMap);
    // ADD TO CHAT HISTORY
    print(response);
    return response!;
  } else {
    return 'It seems you do not have any tasks for this day.';
  }
}

// FLASHCARDS
Future<String> onCreateFlashcards(args, chat) async {
  print("CREATE FLASHCARDS STACK");
  final utcDateTime = DateTime.now().toUtc();
  final epochDate = utcDateTime.millisecondsSinceEpoch;
  Map<String, dynamic> newArgs = {...args, 'date': epochDate};
  print(newArgs);

  final id = randomString(25);
  final success =
      await firebase_CreateDocument('${appName}_Flashcards', id, newArgs);

  if (success) {
    final response = await coco_SendChat(
        chat,
        'The flashcards stack was created and stored in the database with an id of $id. Do not tell the user the id, but remember it for future reference. Let the user know that the note was created and ask what else you can do for them.',
        functionMap);
    return response!;
  } else {
    return 'Something went wrong. The note was not created.';
  }
}

Future<String> onGetAllFlashcards(args, chat) async {
  print("GET FLASHCARDS");
  final userId = args['userId'];

  final taskDocs =
      await firebase_GetAllDocumentsQueried('${appName}_Flashcards', [
    {'field': 'userId', 'operator': '==', 'value': userId},
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
    print(newList);
    final response = await coco_SendChat(
        chat,
        'Turn this JSON into a readable text list format. You do not need to include the id or the userId. JSON: ${jsonEncode(newList)}. Only list the stack names. If they want to view flashcards, ask if they want to view them all or in test mode which means you show them the front card and they give you their answer. Show them the answer (back) and then compare if it is correct or not. Allow them to pass and continue to the next, then come back to it. Once finished, keep track of all correct and incorrect and give them overall score with a full overview of results. Allow randomized or standard order. Also, allow the cards to be reversed, so showing the back card first instead.',
        functionMap);
    // ADD TO CHAT HISTORY
    print(response);
    return response!;
  } else {
    return 'It seems you do not have any tasks for this day.';
  }
}
