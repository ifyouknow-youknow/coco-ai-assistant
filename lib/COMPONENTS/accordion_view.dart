import 'package:flutter/material.dart';

class AccordionView extends StatefulWidget {
  final Widget topWidget;
  final Widget bottomWidget;
  final bool isHorizontal;

  const AccordionView({
    super.key,
    required this.topWidget,
    required this.bottomWidget,
    this.isHorizontal = false,
  });

  @override
  State<AccordionView> createState() => _AccordionViewState();
}

class _AccordionViewState extends State<AccordionView> {
  bool _toggle = false;

  void _toggleAccordion() {
    setState(() {
      _toggle = !_toggle;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isHorizontal) {
      return Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: _toggleAccordion,
              child: Container(
                color: Colors.transparent,
                child: widget.topWidget,
              ),
            ),
          ),
          if (_toggle)
            Expanded(
              child: widget.bottomWidget,
            ),
        ],
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          GestureDetector(
            onTap: _toggleAccordion,
            child: Container(
              width: double.infinity,
              color: Colors.transparent,
              child: widget.topWidget,
            ),
          ),
          if (_toggle) widget.bottomWidget,
        ],
      );
    }
  }
}
