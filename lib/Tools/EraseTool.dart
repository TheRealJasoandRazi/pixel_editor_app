import 'package:flutter/material.dart';
import 'package:pixel_editor_app/Cubit/PaintState.dart';
import '../Cubit/EraseState.dart';
import '../ResubleWidgets/toolBarButtons.dart';
import '../Cubit/DropperState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EraseTool extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final eraseCubit = BlocProvider.of<EraseCubit>(context); // Retrieve from state
    final paintCubit = BlocProvider.of<PaintCubit>(context);
    final dropperCubit = BlocProvider.of<DropperCubit>(context);

    return BlocBuilder<EraseCubit, bool>(
      builder: (context, state) {
        return ToolBarButton(
          icon: Icons.remove,
          action: () {
            eraseCubit.changeSelection();
            if (eraseCubit.state) {
              if (paintCubit.state) {
                paintCubit.changeSelection(); // Turn off the paint button
              }
              if (dropperCubit.state) {
                dropperCubit.changeSelection();
              }
            }
          },
          color: state ? Colors.blue.shade300 : Colors.grey.shade300,
          text: "Eraser is used to turn cells in the grid to transparent",
          tool: "eraser",
        );
      },
    );
  }
}
