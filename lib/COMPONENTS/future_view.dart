import 'package:flutter/material.dart';
import 'package:coco_ai_assistant/COMPONENTS/loading_view.dart';
import 'package:coco_ai_assistant/COMPONENTS/text_view.dart';

class FutureView extends StatefulWidget {
  final Future<dynamic> future;
  final Widget emptyWidget;
  final Widget Function(dynamic data) childBuilder;

  FutureView({
    Key? key,
    required this.future,
    required this.childBuilder,
    required this.emptyWidget,
  }) : super(key: key);

  @override
  State<FutureView> createState() => _FutureViewState();
}

class _FutureViewState extends State<FutureView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: widget.future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingView();
        } else if (snapshot.hasError) {
          return TextView(
            text: 'Error: ${snapshot.error}',
            color: Colors.red,
          );
        } else if (snapshot.hasData) {
          final data = snapshot.data;
          if (data != null && data.isNotEmpty) {
            return widget.childBuilder(data);
          } else {
            return widget.emptyWidget;
          }
        } else {
          return const TextView(text: 'No data');
        }
      },
    );
  }
}
