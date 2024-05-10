import 'package:flutter/material.dart';
import 'PaintTool.dart';

class GridItem extends StatefulWidget {
  final int index;
  final PaintTool paintTool;

  const GridItem({
    Key? key, 
    required this.index,
    required this.paintTool,
  }) : super(key: key);

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  Color defaultColor = Colors.transparent;
  late Color currentColor;

  @override
  void initState() {
    super.initState();
    currentColor = defaultColor;
  }

  void _handleClick() {
    setState(() {
      if(widget.paintTool.colorWheel.getScreenPickerColor == currentColor){
        currentColor = Colors.transparent;
      } else {
        currentColor = widget.paintTool.colorWheel.getScreenPickerColor;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:() {
        if(widget.paintTool.paintSelected)
          _handleClick();
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          color: currentColor,
        ),
      ),
    );
  }
}
