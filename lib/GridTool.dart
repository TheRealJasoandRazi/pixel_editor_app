import 'package:flutter/material.dart';
import 'toolBarButtons.dart';

class GridTool extends StatefulWidget with ToolBarButtons {
  final Function() changeVisibility;

  GridTool({ //pass in the homepage method to change visibility of form
    required this.changeVisibility,
  });

  @override
  _GridToolState createState() => _GridToolState();
}

class _GridToolState extends State<GridTool> {
  
  @override
  Widget build(BuildContext context) {
    return widget.toolBarButton(
      Icons.grid_on,
      widget.changeVisibility,
      Colors.grey.shade300,
    );
  }
}
