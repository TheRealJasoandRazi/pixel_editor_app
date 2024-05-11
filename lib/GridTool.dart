import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'toolBarButtons.dart';
import 'Cubit/Form_State.dart';

class GridTool extends StatefulWidget with ToolBarButtons {

  @override
  _GridToolState createState() => _GridToolState();
}

class _GridToolState extends State<GridTool> {
  
  @override
  Widget build(BuildContext context) {
    final formCubit = BlocProvider.of<FormCubit>(context); //retieve form state

    return widget.toolBarButton(
      Icons.grid_on,
      () {
        formCubit.changeFormVisibility();
      },
      Colors.grey.shade300,
    );
  }
}
