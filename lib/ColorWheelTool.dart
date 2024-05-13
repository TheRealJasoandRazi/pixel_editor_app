import 'package:flutter/material.dart';
import 'package:pixel_editor_app/Cubit/ColorWheelState.dart';
import 'toolBarButtons.dart';
import 'ColorWheelPopUp.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ColorWheelTool extends StatefulWidget with ToolBarButtons {

  @override
  State<ColorWheelTool> createState() => _ColorWheelToolState();
}

class _ColorWheelToolState extends State<ColorWheelTool> {

  @override
  Widget build(BuildContext context) {
    final colorWheelCubit = BlocProvider.of<ColorWheelCubit>(context); //retieve form state

    return widget.toolBarButton(
      Icons.portrait_outlined,
      (){
        colorWheelCubit.changeColorWheelVisibility();
      },
      Colors.grey.shade300,
    );
  }
}