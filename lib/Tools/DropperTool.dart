import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_editor_app/Cubit/DropperState.dart';
import 'package:pixel_editor_app/Cubit/PaintState.dart';
import '../Cubit/EraseState.dart';
import '../ResubleWidgets/toolBarButtons.dart';

class DropperTool extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dropperCubit = BlocProvider.of<DropperCubit>(context);
    final eraseCubit = BlocProvider.of<EraseCubit>(context);
    final paintCubit = BlocProvider.of<PaintCubit>(context);

    return BlocBuilder<DropperCubit, bool>(
      builder: (context, state) {
        return ToolBarButton(
          icon: Icons.water_drop,
          action: () {
            dropperCubit.changeSelection();
            if (eraseCubit.state) {
              eraseCubit.changeSelection();
            }
            if (paintCubit.state) {
              paintCubit.changeSelection();
            }
          },
          color: state ? Colors.blue.shade300 : Colors.grey.shade300,
          text: "Dropper is used to get color from the grid",
          tool: "dropper",
        );
      },
    );
  }
}
