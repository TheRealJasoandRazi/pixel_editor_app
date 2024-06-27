import 'package:flutter/material.dart';
import 'package:pixel_editor_app/Cubit/DropperState.dart';
import 'package:pixel_editor_app/Cubit/PaintState.dart';
import '../Cubit/EraseState.dart';
import '../ResubleWidgets/toolBarButtons.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class DropperTool extends StatelessWidget with ToolBarButtons{

  @override
  Widget build(BuildContext context) {
    final dropperCubit = BlocProvider.of<DropperCubit>(context); //retieve form state
    final eraseCubit = BlocProvider.of<EraseCubit>(context); //retieve form state
    final paintCubit = BlocProvider.of<PaintCubit>(context);

    return BlocBuilder<DropperCubit, bool>(
      builder: (context, state) {
        return toolBarButton(
          Icons.water_drop,
          (){
            dropperCubit.changeSelection();
            if(eraseCubit.state){
              eraseCubit.changeSelection();
            }
            if(paintCubit.state){
              paintCubit.changeSelection();
            }
          },
          state ? Colors.blue.shade300 : Colors.grey.shade300,
          "Dropper"
        );
      }
    );
  }
}