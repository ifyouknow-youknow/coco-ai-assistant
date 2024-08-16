import 'package:flutter/material.dart';

Future<void> nav_Push(BuildContext context, Widget page,
    [VoidCallback? onPop]) async {
  await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
  onPop?.call();
}

void nav_Pop(BuildContext context) {
  Navigator.pop(context);
}

void nav_PushAndRemove(BuildContext context, Widget page) {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => page),
    (Route<dynamic> route) => false,
  );
}

bool nav_HasRoutes(BuildContext context) {
  return Navigator.canPop(context);
}
