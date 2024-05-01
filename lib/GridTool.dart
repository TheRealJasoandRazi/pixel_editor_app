import 'package:flutter/material.dart';
import 'toolBarButtons.dart';

class GridTool extends StatefulWidget with ToolBarButtons {
  final Function() changeVisibility;

  GridTool({
    required this.changeVisibility,
  });

  @override
  _GridToolState createState() => _GridToolState();
}

class _GridToolState extends State<GridTool> {
  /*void _toggleFormVisibility() {
    print("ICON CLICKED");
    widget.isFormVisible = !widget.isFormVisible;
    widget.rebuildHomePage();
  }*/

  @override
  Widget build(BuildContext context) {
    return widget.toolBarButton(
      Icons.grid_on,
      widget.changeVisibility,
      Colors.grey.shade300,
    );
  }
}
