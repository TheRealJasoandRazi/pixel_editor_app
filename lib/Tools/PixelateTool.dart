import 'package:flutter/material.dart';
import '../Cubit/PixelateState.dart';
import '../toolBarButtons.dart';

import '../Cubit/PaintState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PixelateTool extends StatelessWidget with ToolBarButtons {
  @override
  Widget build(BuildContext context) {
    final pixelateCubit = BlocProvider.of<PixelateCubit>(context);
  
    return BlocBuilder<PixelateCubit, bool>( //rebuilds whenever paint state changes
      builder: (context, state) {
        return toolBarButton(
          Icons.pix,
          (){
            pixelateCubit.changePixelateFormVisibility();
          },
          state ? Colors.blue.shade300 : Colors.grey.shade300,
          "Pixelate"
        );
      },
    );
  }
}