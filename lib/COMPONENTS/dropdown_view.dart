import 'package:flutter/material.dart';

class DropdownView extends StatefulWidget {
  final List<String> items;
  final ValueChanged<String>? onChanged;
  final Color textColor;
  final Color backgroundColor;
  final String? defaultValue; // Make defaultValue nullable

  const DropdownView({
    super.key,
    required this.items,
    required this.onChanged,
    this.backgroundColor = Colors.transparent,
    this.textColor = Colors.black,
    this.defaultValue, // Accept defaultValue in constructor
  });

  @override
  _DropdownViewState createState() => _DropdownViewState();
}

class _DropdownViewState extends State<DropdownView> {
  late String _selectedItem;

  @override
  void initState() {
    super.initState();
    // Initialize _selectedItem with defaultValue if provided, otherwise first item in the list
    if (widget.defaultValue != null &&
        widget.items.contains(widget.defaultValue)) {
      _selectedItem = widget.defaultValue!;
    } else {
      _selectedItem = widget.items[0];
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      dropdownColor: widget.backgroundColor,
      style: TextStyle(
        color: widget.textColor,
        fontSize: 20,
        backgroundColor: widget.backgroundColor,
      ),
      value: _selectedItem,
      items: widget.items.map((String item) {
        return DropdownMenuItem(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedItem = value!;
        });
        if (widget.onChanged != null) {
          widget.onChanged!(value!);
        }
      },
    );
  }
}
