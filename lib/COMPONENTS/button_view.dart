import 'package:flutter/material.dart';
import 'package:coco_ai_assistant/FUNCTIONS/colors.dart'; // Ensure this file has the `hexToColor` function.

class ButtonView extends StatefulWidget {
  final Widget child;
  final Color backgroundColor;
  final double radius;
  final double paddingTop;
  final double paddingLeft;
  final double paddingRight;
  final double paddingBottom;
  final VoidCallback onPress;

  const ButtonView({
    super.key,
    required this.child,
    this.backgroundColor = Colors.transparent,
    this.radius = 0.0,
    this.paddingTop = 0.0,
    this.paddingLeft = 0.0,
    this.paddingRight = 0.0,
    this.paddingBottom = 0.0,
    required this.onPress,
  });

  @override
  _ButtonViewState createState() => _ButtonViewState();
}

class _ButtonViewState extends State<ButtonView> {
  double _opacity = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _opacity = 0.6; // Reduce opacity on tap down
    });
  }

  void _onTapUp(TapUpDetails details) {
    setState(() {
      _opacity = 1.0; // Restore opacity on tap up
    });
  }

  void _onTapCancel() {
    setState(() {
      _opacity = 1.0; // Restore opacity if tap is cancelled
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: widget.onPress,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 100),
        opacity: _opacity,
        child: IntrinsicWidth(
          child: Container(
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              borderRadius: BorderRadius.circular(widget.radius),
            ),
            padding: EdgeInsets.only(
              top: widget.paddingTop,
              left: widget.paddingLeft,
              right: widget.paddingRight,
              bottom: widget.paddingBottom,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
