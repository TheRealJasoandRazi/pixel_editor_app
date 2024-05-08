import 'package:flutter/material.dart';
import 'toolBarButtons.dart';
import 'ColorWheelPopUp.dart';

class PaintTool extends StatefulWidget with ToolBarButtons {
  bool _paintSelected = false; //leave variable outside, it needs to be accessable from outside
  bool get paintSelected => _paintSelected;
  ColorWheelPopUp colorWheel;
  
  PaintTool({
    Key? key, 
    required ColorWheelPopUp this.colorWheel
  }) : super(key: key);

  @override
  _PaintToolState createState() => _PaintToolState();
}

class _PaintToolState extends State<PaintTool> {
  Color buttonColor = Colors.grey.shade300;

  // changes icon colour to signify to user if its active or not
  void _togglePaintButton() {
    setState(() {
      widget._paintSelected = !widget._paintSelected;
      buttonColor = widget._paintSelected ? Colors.blue.shade300 : Colors.grey.shade300;
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