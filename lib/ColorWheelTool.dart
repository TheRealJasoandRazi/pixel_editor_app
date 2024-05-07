import 'package:flutter/material.dart';
import 'toolBarButtons.dart';

class ColorWheelTool extends StatefulWidget with ToolBarButtons {
  final Function() changeColorWheelVisibility;

  const ColorWheelTool({
    required this.changeColorWheelVisibility,
  });

  @override
  State<ColorWheelTool> createState() => _ColorWheelToolState();
}

class _ColorWheelToolState extends State<ColorWheelTool> {
  @override
  Widget build(BuildContext context) {
    return widget.toolBarButton(
      Icons.portrait_outlined,
      widget.changeColorWheelVisibility,
      Colors.grey.shade300,
    );
  }
}