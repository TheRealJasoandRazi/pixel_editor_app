import 'package:flutter/material.dart';
import 'package:pixel_editor_app/Cubit/ColorWheelState.dart';
import '../toolBarButtons.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ColorWheelTool extends StatelessWidget with ToolBarButtons{

  @override
  Widget build(BuildContext context) {
    final colorWheelCubit = BlocProvider.of<ColorWheelCubit>(context); //retieve form state

    return BlocBuilder<ColorWheelCubit, bool>(
      builder: (context, state) {
        return toolBarButton(
          Icons.portrait_outlined,
          (){
            colorWheelCubit.changeColorWheelVisibility();
          },
          state ? Colors.blue.shade300 : Colors.grey.shade300,
          context
        );
      }
    );
  }
}