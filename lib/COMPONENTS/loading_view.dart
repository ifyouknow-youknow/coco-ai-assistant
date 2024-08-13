import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:coco_ai_assistant/COMPONENTS/text_view.dart';

class LoadingView extends StatelessWidget {
  const LoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
      child: Container(
        color: Colors.black.withOpacity(0.7),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextView(
                text: "One moment please...",
                color: Colors.white,
                size: 20,
                font: 'inconsolata',
              ),
              SizedBox(
                height: 10,
              ),
              CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
