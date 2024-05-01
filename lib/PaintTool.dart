import 'package:flutter/material.dart';
import 'toolBarButtons.dart';

class PaintTool extends StatefulWidget with ToolBarButtons {

  @override
  _PaintToolState createState() => _PaintToolState();
}

class _PaintToolState extends State<PaintTool> {
  bool paintSelected = false;
  Color buttonColor = Colors.grey.shade300;

  // changes icon colour to signify to user if its active or not
  void _togglePaintButton() {
    setState(() {
      paintSelected = !paintSelected;
      buttonColor = paintSelected ? Colors.blue.shade300 : Colors.grey.shade300;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.toolBarButton(
      Icons.format_paint,
      _togglePaintButton,
      buttonColor,
    );
  }
}