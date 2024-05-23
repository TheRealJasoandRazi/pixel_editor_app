import 'package:flutter/material.dart';
import 'package:pixel_editor_app/Cubit/GridListState.dart';
import 'toolBarButtons.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class BinTool extends StatelessWidget with ToolBarButtons{

  @override
  Widget build(BuildContext context) {
    final gridListCubit = BlocProvider.of<GridListCubit>(context);
    return toolBarButton(
      Icons.delete,
      (){
        gridListCubit.removeSelectedGrids();
      },
      Colors.grey.shade300,
      context
    );
  }
}