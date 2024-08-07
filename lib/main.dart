import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:coco_ai_assistant/MODELS/firebase.dart';
import 'package:coco_ai_assistant/VIEWS/home.dart';
import 'package:coco_ai_assistant/VIEWS/playground.dart';
import 'package:coco_ai_assistant/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  messaging_SetUp();
  await dotenv.load(fileName: "lib/.env");

  runApp(const MaterialApp(
    home: Home(),
    // initialRoute: "/",
    // routes: {
    //   // "/": (context) => const PlaygroundView(),
    // },
  ));
}
