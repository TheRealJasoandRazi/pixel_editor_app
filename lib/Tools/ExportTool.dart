import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_editor_app/Cubit/EraseState.dart';

import '../toolBarButtons.dart';
import '../Cubit/ExportState.dart';
import '../Cubit/PaintState.dart';
import '../Cubit/FormState.dart';

class ExportTool extends StatelessWidget with ToolBarButtons {
  
  @override
  Widget build(BuildContext context) {
    final exportCubit = BlocProvider.of<ExportCubit>(context); //retieve form state
    final paintCubit = BlocProvider.of<PaintCubit>(context); //retieve form state
    final formCubit = BlocProvider.of<FormCubit>(context); //retieve form state
    final eraseCubit = BlocProvider.of<EraseCubit>(context);

    return BlocBuilder<ExportCubit, bool>(
      builder: (context, state) {
        return toolBarButton(
          Icons.local_shipping,
          () {
            exportCubit.changeExportFormVisibility();
            if(exportCubit.state){ //turns off paint and grid tools
              if(paintCubit.state){
                paintCubit.changeSelection();
              }
              if(formCubit.state){
                formCubit.changeFormVisibility();
              }
              if(eraseCubit.state){
                eraseCubit.changeSelection();
              }
            }
          },
          state ? Colors.blue.shade300 : Colors.grey.shade300,
          context
        );
      }
    );
  }
}
