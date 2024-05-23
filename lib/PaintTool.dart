import 'package:flutter/material.dart';
import 'toolBarButtons.dart';
import 'Cubit/EraseState.dart';

import 'Cubit/PaintState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaintTool extends StatelessWidget with ToolBarButtons {
  @override
  Widget build(BuildContext context) {
    final paintCubit = BlocProvider.of<PaintCubit>(context); //retieve form state
    final eraseCubit = BlocProvider.of<EraseCubit>(context); //retieve form state
    
    return BlocBuilder<PaintCubit, bool>( //rebuilds whenever paint state changes
      builder: (context, state) {
        return toolBarButton(
          Icons.format_paint,
          (){
            paintCubit.changeSelection();
            if(eraseCubit.state && paintCubit.state){
              eraseCubit.changeSelection(); //turn off the erase button 
            }
          },
          state ? Colors.blue.shade300 : Colors.grey.shade300,
          context
        );
      },
    );
  }
}