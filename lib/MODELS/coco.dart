import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

final geminiKey = dotenv.env['GEMINI_KEY'] ?? "";
final safetySettings = [
  SafetySetting(HarmCategory.harassment, HarmBlockThreshold.none),
  SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.none),
  SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.none),
  SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.none),
];

// FUNCTIONS
final declaration_TestFunction = FunctionDeclaration(
  'testFunction',
  'Say hello to the user.',
  Schema(
    SchemaType.object,
    properties: {
      'message':
          Schema(SchemaType.string, description: 'String saying hello user!'),
    },
    requiredProperties: [
      'message',
    ],
  ),
);

// FUNCTION CALLS

Future<String?> coco_Send(
  String prompt,
  String instructions,
  Function function,
) async {
  final model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: geminiKey,
    safetySettings: safetySettings,
    systemInstruction: Content.text(instructions),
    tools: [
      Tool(functionDeclarations: [declaration_TestFunction])
    ],
  );

  final content = [
    Content.multi([
      TextPart(prompt),
    ])
  ];

  var response = await model.generateContent(content);
  final functionCalls = response.functionCalls.toList();

  if (functionCalls.isNotEmpty) {
    final functionCall = functionCalls.first;
    final userResponse = await function(functionCall);
    final newContent = [Content.text(userResponse)];
    final secondResponse = await model.generateContent(newContent);
    return secondResponse.text;
  }

  return response.text ?? "No response.";
}

// MULTITURN
// START CHAT
Future<ChatSession> coco_StartChat(String instructions) async {
  final model = GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: geminiKey,
      safetySettings: safetySettings,
      systemInstruction: Content.text(instructions));

  final chat = model.startChat(history: []);
  return chat;
}

// CUSTOM
Future<ChatSession> coco_StartCustomChat(
    String instructions, List<FunctionDeclaration> declarations) async {
  final model = GenerativeModel(
    model: 'gemini-1.5-flash-latest',
    apiKey: geminiKey,
    safetySettings: safetySettings,
    systemInstruction: Content.text(instructions),
    tools: [Tool(functionDeclarations: declarations)],
  );

  final chat = model.startChat(history: []);
  return chat;
}

// SEND MESSAGE
Future<String?> coco_SendChat(
    ChatSession chat, String message, Map<String, Function> functions) async {
  try {
    print(functions);
    final response = await chat.sendMessage(Content.text(message));
    final text = response.text ?? "No response";

    final functionCalls = response.functionCalls.toList();

    if (functionCalls.isNotEmpty) {
      final functionCall = functionCalls.first;
      final functionName = functionCall.name;
      final functionArgs = functionCall.args;
      final functionResponse = functions[functionName]!(functionArgs, chat);
      return functionResponse;
    } else {
      return text;
    }
  } catch (e) {
    print('Error sending chat: $e');
    return null;
    // Handle the error, e.g., show an error message to the user
  }
}

// FUNCTIONS
String onDoSomething(args) {
  return args.message;
}
