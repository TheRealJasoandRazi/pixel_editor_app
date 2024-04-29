import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'toolBarButton.dart';

class PaintTool extends StatefulWidget with ToolBarButtons {

  @override
  _PaintToolState createState() => _PaintToolState();
}

class _PaintToolState extends State<PaintTool> {
  bool paintSelected = false;
  Color buttonColor = Colors.grey.shade300;

  // Method to handle paint button toggle
  void _togglePaintButton() {
    setState(() {
      paintSelected = !paintSelected;
      buttonColor = paintSelected ? Colors.blue.shade300 : Colors.grey.shade300;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Call the inherited toolBarButton function to create the toolbar button
    return widget.toolBarButton(
      Icons.format_paint,
      _togglePaintButton,
      buttonColor,
    );
  }
}