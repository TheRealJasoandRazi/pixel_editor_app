import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'toolBarButtons.dart';
import 'Cubit/FormState.dart';

class GridTool extends StatelessWidget with ToolBarButtons {
  
  @override
  Widget build(BuildContext context) {
    final formCubit = BlocProvider.of<FormCubit>(context); //retieve form state

    return BlocBuilder<FormCubit, bool>(
      builder: (context, state) {
        return toolBarButton(
          Icons.grid_on,
          () {
            formCubit.changeFormVisibility();
          },
          state ? Colors.blue.shade300 : Colors.grey.shade300,
          context
        );
      }
    );
  }
}
