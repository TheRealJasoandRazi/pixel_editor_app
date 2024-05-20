import 'package:flutter/material.dart';
import 'package:pixel_editor_app/Cubit/GridListState.dart';
import 'toolBarButtons.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class BinTool extends StatefulWidget with ToolBarButtons {

  @override
  _BinToolState createState() => _BinToolState();
}

class _BinToolState extends State<BinTool> {

  @override
  Widget build(BuildContext context) {
    final gridListCubit = BlocProvider.of<GridListCubit>(context);
    return widget.toolBarButton(
      Icons.recycling,
      (){
        gridListCubit.removeSelectedGrids();
      },
      Colors.grey.shade300,
      context
    );
  }
}