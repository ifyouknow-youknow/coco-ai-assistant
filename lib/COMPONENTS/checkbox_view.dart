import 'package:flutter/material.dart';
import 'package:coco_ai_assistant/FUNCTIONS/colors.dart';

class CheckboxView extends StatefulWidget {
  final ValueChanged<bool> onChange;
  final String fillColor;
  final String checkColor;

  const CheckboxView({
    super.key,
    required this.onChange,
    this.fillColor = "#117DFA",
    this.checkColor = "#ffffff",
  });

  @override
  State<CheckboxView> createState() => _CheckboxViewState();
}

class _CheckboxViewState extends State<CheckboxView> {
  bool _isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      activeColor: hexToColor(widget.fillColor),
      checkColor: hexToColor(widget.checkColor),
      value: _isSelected,
      onChanged: (bool? value) {
        setState(() {
          _isSelected = value ?? false;
        });
        widget.onChange(_isSelected);
      },
    );
  }
}
