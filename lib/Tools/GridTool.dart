import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_editor_app/Cubit/ExportState.dart';
import 'package:pixel_editor_app/ExportForm.dart';

import '../toolBarButtons.dart';
import '../Cubit/FormState.dart';

class GridTool extends StatelessWidget with ToolBarButtons {
  
  @override
  Widget build(BuildContext context) {
    final formCubit = BlocProvider.of<FormCubit>(context); //retieve form state
    final exportCubit = BlocProvider.of<ExportCubit>(context);

    return BlocBuilder<FormCubit, bool>(
      builder: (context, state) {
        return toolBarButton(
          Icons.grid_on,
          () {
            formCubit.changeFormVisibility();
            if(formCubit.state){
              if(exportCubit.state){
                exportCubit.changeExportFormVisibility();
              }
            }
          },
          state ? Colors.blue.shade300 : Colors.grey.shade300,
          "Create Grid"
        );
      }
    );
  }
}
