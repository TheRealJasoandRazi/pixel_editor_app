import 'package:flutter/material.dart';
import 'toolBarButtons.dart';

import 'Cubit/PaintState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaintTool extends StatefulWidget with ToolBarButtons {

  @override
  _PaintToolState createState() => _PaintToolState();
}

class _PaintToolState extends State<PaintTool> {
  Color buttonColor = Colors.grey.shade300;

  // changes icon colour to signify to user if its active or not
  void _togglePaintButton(state) {
    setState(() {
      buttonColor = state ? Colors.blue.shade300 : Colors.grey.shade300;
    });
  }

  @override
  Widget build(BuildContext context) {
    final paintCubit = BlocProvider.of<PaintCubit>(context); //retieve form state
    
    return widget.toolBarButton(
      Icons.format_paint,
      (){
        paintCubit.changeSelection();
        _togglePaintButton(paintCubit.state);
      },
      buttonColor,
      context
    );
  }
}