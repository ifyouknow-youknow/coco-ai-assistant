import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coco_ai_assistant/FUNCTIONS/date.dart';
import 'package:coco_ai_assistant/FUNCTIONS/misc.dart';
import 'package:coco_ai_assistant/MODELS/JOBS/jobs.dart';
import 'package:coco_ai_assistant/MODELS/coco.dart';
import 'package:coco_ai_assistant/MODELS/constants.dart';
import 'package:coco_ai_assistant/MODELS/firebase.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

final tasks_instructions =
    'You are a task manager. This job involves creating new tasks, updating tasks, removing tasks, and sharing tasks with other users. Use the provided functions to interact with the main database which stores all of the task data.';

// FUNCTIONS
final declaration_CreateTask = FunctionDeclaration(
  'createTask',
  'Creates a new task record in the database. Remember this information. Use this it the user has requested to create a new task and not update.',
  Schema(
    SchemaType.object,
    properties: {
      'id': Schema(SchemaType.string,
          description:
              'A random string of characters with a length of 25 characters. Only letters and numbers (MIX OF BOTH). Make it very random like uuid. Do not allow duplicate ids.'),
      'userId': Schema(SchemaType.string, description: 'The id of the user.'),
      'task': Schema(SchemaType.string,
          description:
              'The task in tet form. This should be generalized and based on what the user says.'),
      'category': Schema(SchemaType.string,
          description:
              'The category that the task belongs in. Do not use category names that are too unique so you can put multiple tasks in a category if they fit such as Work, Personal, etc.'),
      'date': Schema(SchemaType.string,
          description:
              'The date this task is meant to be completed on. If no date is specified, set today local time as the date. Make sure it is in this format: “2024-08-05T12:34:56Z”.'),
      'priority': Schema(SchemaType.string,
          description: 'The priority of this task. Set to LOW as default.'),
      'status': Schema(SchemaType.string,
          description: 'Set this status initially to IN PROCESS.'),
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
final declaration_UpdateTask = FunctionDeclaration(
  'updateTask',
  'Update an existing task a new task record from the database. Use the id. Do not ask for the id, just use the ones that you already know. Only call if the user wants to update and not create a task.',
  Schema(
    SchemaType.object,
    properties: {
      'id': Schema(SchemaType.string,
          description:
              'Do not update this. This should be the same id as the task that the user wants to update.'),
      'userId': Schema(SchemaType.string, description: 'The id of the user.'),
      'task': Schema(SchemaType.string,
          description:
              'The task in tet form. This should be generalized and based on what the user says.'),
      'category': Schema(SchemaType.string,
          description:
              'The category that the task belongs in. Do not use category names that are too unique so you can put multiple tasks in a category if they fit such as Work, Personal, etc.'),
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
final declaration_GetTasks = FunctionDeclaration(
  'getTasks',
  'Get all tasks for the specified day.',
  Schema(
    SchemaType.object,
    properties: {
      'userId': Schema(SchemaType.string, description: 'The id of the user.'),
      'date': Schema(SchemaType.string,
          description:
              'The date the user wants to get tasks for. If no date is specified, assume it is for today ${DateTime.now().toLocal()}. Make sure you return in this format: "YYYY-MM-DDTHH:MM:SSZ"'),
    },
    requiredProperties: ['userId', 'date'],
  ),
);

//

List<FunctionDeclaration> declarations_tasks = [
  declaration_ChooseJob,
  declaration_CreateTask,
  declaration_UpdateTask,
  declaration_GetTasks
];

//

final taskFunctions = {
  'chooseJob': onChooseJob,
  'createTask': onCreateTask,
  'updateTask': onUpdateTask,
  'getTasks': onGetTasks
};

Future<String> onCreateTask(args, chat) async {
  print("CREATE TASK");
  print(args);
  final utcDateTime = DateTime.parse(args['date']).toUtc();
  final epochDate = utcDateTime.millisecondsSinceEpoch;
  Map<String, dynamic> newArgs = {...args, 'date': epochDate};
  final id = randomString(25);
  final success =
      await firebase_CreateDocument('${appName}_Tasks', id, newArgs);

  if (success) {
    final response = await coco_SendChat(
        chat,
        'The task was created and stored in the database with an id of $id. Do not tell the user the id, but remember it for future reference. Let the user know that the task was create and ask what else you can do for them.',
        taskFunctions);
    return response!;
  } else {
    return 'Something went wrong. The task was not created.';
  }
}

Future<String> onUpdateTask(args, chat) async {
  print("UPDATE TASK");
  print(args);
  final utcDateTime = DateTime.parse(args['date']).toUtc();
  final epochDate = utcDateTime.millisecondsSinceEpoch;
  Map<String, dynamic> newArgs = {...args, 'date': epochDate};
  final success =
      await firebase_UpdateDocument('${appName}_Tasks', args['id'], newArgs);
  if (success) {
    return 'Your task has been updated. What else can I do for you?';
  } else {
    return 'Something went wrong. The task was not updated.';
  }
}

Future<String> onGetTasks(args, chat) async {
  print("GET TASKS");
  final userId = args['userId'];
  final dateStr = args['date'];
  final epochDate = DateTime.parse(dateStr).toUtc();
  print(epochDate);
  final startDate = DateTime(epochDate.year, epochDate.month, epochDate.day)
      .millisecondsSinceEpoch;
  final endDate =
      DateTime(epochDate.year, epochDate.month, epochDate.day, 23, 59, 59, 999)
          .millisecondsSinceEpoch;

  final taskDocs = await firebase_GetAllDocumentsQueried('${appName}_Tasks', [
    {'field': 'userId', 'operator': '==', 'value': userId},
    {'field': 'date', 'operator': '>=', 'value': startDate},
  ]);
  print(taskDocs);
  if (taskDocs.isNotEmpty) {
    final newList = taskDocs.map((ting) {
      return {
        ...ting,
        'date': DateTime.fromMillisecondsSinceEpoch(ting['date'])
            .toLocal()
            .toIso8601String()
      };
    }).toList();
    final response = await coco_SendChat(
        chat,
        'Turn this JSON into a readable text list format. You do not need to include the id or the userId, but remember it in case you need to update a task. JSON: ${jsonEncode(newList)}. Only tell me the ones specified for this day. ${formatDate(DateTime.now())}',
        taskFunctions);
    // ADD TO CHAT HISTORY
    print(response);
    return response!;
  } else {
    return 'It seems you do not have any tasks for this day.';
  }
}
