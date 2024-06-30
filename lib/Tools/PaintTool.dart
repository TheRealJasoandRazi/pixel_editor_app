import 'package:flutter/material.dart';
import '../ResubleWidgets/toolBarButtons.dart';
import '../Cubit/EraseState.dart';
import '../Cubit/DropperState.dart';
import '../Cubit/PaintState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaintTool extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final paintCubit = BlocProvider.of<PaintCubit>(context); // Retrieve from state
    final eraseCubit = BlocProvider.of<EraseCubit>(context); // Retrieve from state
    final dropperCubit = BlocProvider.of<DropperCubit>(context);

    return BlocBuilder<PaintCubit, bool>( // Rebuilds whenever paint state changes
      builder: (context, state) {
        return ToolBarButton(
          icon: Icons.format_paint,
          action: () {
            paintCubit.changeSelection();
            if (paintCubit.state) {
              if (eraseCubit.state) {
                eraseCubit.changeSelection(); // Turn off the erase button
              } 
              if (dropperCubit.state) {
                dropperCubit.changeSelection();
              }
            }
          },
          color: state ? Colors.blue.shade300 : Colors.grey.shade300,
          text: "Painter is used to fill in cells with the current color",
          tool: "painter",
        );
      },
    );
  }
}
