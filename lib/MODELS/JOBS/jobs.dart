// FUNCTIONS
import 'package:google_generative_ai/google_generative_ai.dart';

final declaration_ChooseJob = FunctionDeclaration(
  'chooseJob',
  'Depending on the user request, choose which job you are meant to do. Only call this function when the user makes a request for a specific job. Do not run if you are already getting information from the user to complete the request.',
  Schema(
    SchemaType.object,
    properties: {
      'job': Schema(SchemaType.string,
          description:
              'Select one of this list which indicates the job that the user needs to be done: tasks, finances, general question.'),
    },
    requiredProperties: [
      'job',
    ],
  ),
);

final jobFunctions = {'chooseJob': onChooseJob};

String onChooseJob(args, chat) {
  return args['job'];
}
