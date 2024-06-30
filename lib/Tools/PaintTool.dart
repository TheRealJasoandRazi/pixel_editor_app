import 'package:flutter/material.dart';
import '../ResubleWidgets/toolBarButtons.dart';
import '../Cubit/EraseState.dart';
import '../Cubit/DropperState.dart';

import '../Cubit/PaintState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaintTool extends StatelessWidget with ToolBarButtons {
  @override
  Widget build(BuildContext context) {
    final paintCubit = BlocProvider.of<PaintCubit>(context); //retieve form state
    final eraseCubit = BlocProvider.of<EraseCubit>(context); //retieve form state
    final dropperCubit = BlocProvider.of<DropperCubit>(context);

    return BlocBuilder<PaintCubit, bool>( //rebuilds whenever paint state changes
      builder: (context, state) {
        return toolBarButton(
          Icons.format_paint,
          (){
            paintCubit.changeSelection();
            if(paintCubit.state) {
              if(eraseCubit.state){
                eraseCubit.changeSelection(); //turn off the erase button
              } 
              if(dropperCubit.state){
                dropperCubit.changeSelection();
              }
            }
          },
          state ? Colors.blue.shade300 : Colors.grey.shade300,
          "Painter is used to fill in cells with the current color",
          context,
          "painter"
        );
      },
    );
  }
}