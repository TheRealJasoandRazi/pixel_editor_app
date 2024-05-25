import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../toolBarButtons.dart';
import '../Cubit/ExportState.dart';

class ExportTool extends StatelessWidget with ToolBarButtons {
  
  @override
  Widget build(BuildContext context) {
    final exportCubit = BlocProvider.of<ExportCubit>(context); //retieve form state

    return BlocBuilder<ExportCubit, bool>(
      builder: (context, state) {
        return toolBarButton(
          Icons.local_shipping,
          () {
            exportCubit.changeExportFormVisibility();
          },
          state ? Colors.blue.shade300 : Colors.grey.shade300,
          context
        );
      }
    );
  }
}
