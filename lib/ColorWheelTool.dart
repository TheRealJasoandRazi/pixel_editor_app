import 'package:flutter/material.dart';
import 'toolBarButtons.dart';
import 'ColorWheelPopUp.dart';

class ColorWheelTool extends StatefulWidget with ToolBarButtons {
  final Function() reload;
  final ColorWheelPopUp colorWheelPopUp = ColorWheelPopUp(); //initialise popup here
  bool colorWheelVisibility = false;

  ColorWheelTool({
    required this.reload,
  });

  @override
  State<ColorWheelTool> createState() => _ColorWheelToolState();
}

class _ColorWheelToolState extends State<ColorWheelTool> {
  void changeColorWheelVisibility(){
    setState(() {
      widget.colorWheelVisibility = !widget.colorWheelVisibility;
    });
    widget.reload();
  }

  @override
  Widget build(BuildContext context) {
    return widget.toolBarButton(
      Icons.portrait_outlined,
      changeColorWheelVisibility,
      Colors.grey.shade300,
    );
  }
}