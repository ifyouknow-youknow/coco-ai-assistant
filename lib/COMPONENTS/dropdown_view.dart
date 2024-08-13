import 'package:flutter/material.dart';

class DropdownView extends StatefulWidget {
  final List<String> items;
  final ValueChanged<String>? onChanged;
  final Color textColor;
  final Color backgroundColor;

  const DropdownView(
      {super.key,
      required this.items,
      required this.onChanged,
      this.backgroundColor = Colors.transparent,
      this.textColor = Colors.black});

  @override
  _DropdownViewState createState() => _DropdownViewState();
}

class _DropdownViewState extends State<DropdownView> {
  late String _selectedItem;

  @override
  void initState() {
    super.initState();
    // Initialize _selectedItem with the first item in the list
    _selectedItem = widget.items[0];
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      dropdownColor: widget.backgroundColor,
      style: TextStyle(
          color: widget.textColor,
          fontSize: 20,
          backgroundColor: widget.backgroundColor),
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
