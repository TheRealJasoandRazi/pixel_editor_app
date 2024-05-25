import 'package:flutter/material.dart';
import 'package:pixel_editor_app/Cubit/PaintState.dart';
import '../Cubit/EraseState.dart';
import '../toolBarButtons.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class EraseTool extends StatelessWidget with ToolBarButtons{

  @override
  Widget build(BuildContext context) {
    final eraseCubit = BlocProvider.of<EraseCubit>(context); //retieve form state
    final paintCubit = BlocProvider.of<PaintCubit>(context);

    return BlocBuilder<EraseCubit, bool>(
      builder: (context, state) {
        return toolBarButton(
          Icons.remove,
          (){
            eraseCubit.changeSelection();
            if(eraseCubit.state && paintCubit.state){
                paintCubit.changeSelection(); //turn off the paint button 
            }
          },
          state ? Colors.blue.shade300 : Colors.grey.shade300,
          context
        );
      }
    );
  }
}