import 'package:flutter/material.dart';

class CheckboxView extends StatefulWidget {
  final ValueChanged<bool> onChange;
  final Color fillColor;
  final Color checkColor;
  final bool defaultValue;
  final double width;
  final double height;

  const CheckboxView({
    Key? key,
    required this.onChange,
    this.fillColor = Colors.blue,
    this.checkColor = Colors.white,
    this.defaultValue = false,
    this.width = 25.0, // Default width
    this.height = 25.0, // Default height
  }) : super(key: key);

  @override
  State<CheckboxView> createState() => _CheckboxViewState();
}

class _CheckboxViewState extends State<CheckboxView> {
  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.defaultValue;
  }

  @override
  void didUpdateWidget(covariant CheckboxView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update _isSelected when the defaultValue changes
    if (oldWidget.defaultValue != widget.defaultValue) {
      setState(() {
        _isSelected = widget.defaultValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: Transform.scale(
        scale: widget.width /
            25.0, // Scale the checkbox to fit the specified width
        child: Checkbox(
          activeColor: widget.fillColor,
          checkColor: widget.checkColor,
          value: _isSelected,
          onChanged: (bool? value) {
            setState(() {
              _isSelected = value ?? false;
            });
            widget.onChange(_isSelected);
          },
        ),
      ),
    );
  }
}
