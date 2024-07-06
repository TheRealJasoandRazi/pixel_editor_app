import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_editor_app/Cubit/EraseState.dart';
import 'package:pixel_editor_app/Cubit/GridListState.dart';
import '../Cubit/PaintState.dart';
import '../Cubit/ColorState.dart';
import '../Cubit/DropperState.dart';
import '../Grid.dart';

class CreateGrid extends StatefulWidget {
  final int width;
  final int height;
  final Grid? thisLayer;

   CreateGrid({
    required Grid layer,
  }) : height = layer.listOfViews[layer.editable].length,
       width = layer.listOfViews[layer.editable][0].length,
       thisLayer = layer;

  @override
  State<CreateGrid> createState() => _CreateGridState();
}

class _CreateGridState extends State<CreateGrid> {
  late PaintCubit paintCubit;
  late ColorCubit colorCubit;
  late EraseCubit eraseCubit;
  late DropperCubit dropperCubit;
  late GridListCubit gridListCubit;

  late double cellWidth;
  late double cellHeight;

  late double gridWidthFactor;
  late double gridHeightFactor;

  @override
  void initState() {
    super.initState();
    // Initialize BLoCs
    paintCubit = BlocProvider.of<PaintCubit>(context);
    colorCubit = BlocProvider.of<ColorCubit>(context);
    eraseCubit = BlocProvider.of<EraseCubit>(context);
    dropperCubit = BlocProvider.of<DropperCubit>(context);
    gridListCubit = BlocProvider.of<GridListCubit>(context);
  }

  void _calculateGridIndex(Offset localPosition, Color color) {
    final column = (localPosition.dx / cellWidth).floor().clamp(0, widget.width - 1);
    final row = (localPosition.dy / cellHeight).floor().clamp(0, widget.height - 1);
    setState(() { //rebuild itself
      widget.thisLayer!.editLayer(row, column, color); //edit layer
    });
  }

  void _handleClick(Offset localPosition, ColorCubit colorCubit) {
    final column = (localPosition.dx / cellWidth).floor().clamp(0, widget.width - 1);
    final row = (localPosition.dy / cellHeight).floor().clamp(0, widget.height - 1);

    setState(() {
      if(paintCubit.state){
        if (colorCubit.state == widget.thisLayer!.getColor(row, column)) {
          widget.thisLayer!.editLayer(row, column, Colors.transparent); 
        } else {
          widget.thisLayer!.editLayer(row, column, colorCubit.state);
        }
      } else if (eraseCubit.state){
        widget.thisLayer!.editLayer(row, column, Colors.transparent); 
      } else if (dropperCubit.state){
        Color newColor = widget.thisLayer!.getColor(row, column);
        colorCubit.changeColor(newColor);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    gridWidthFactor = 0.7;
    gridHeightFactor = 0.6;

    return LayoutBuilder( //to get parent size
      builder: (context, constraints) {
        cellWidth = (constraints.maxWidth * 0.7) / widget.width;
        cellHeight = (constraints.maxHeight * 0.6) / widget.height;
        return GestureDetector(
          onTapDown: (details) {
            if (paintCubit.state || eraseCubit.state || dropperCubit.state) {
              _handleClick(details.localPosition, colorCubit);
            }
          },
          onPanUpdate: (details) {
            if (paintCubit.state) {
              _calculateGridIndex(details.localPosition, colorCubit.state);
            } else if (eraseCubit.state) {
              _calculateGridIndex(details.localPosition, Colors.transparent);
            }
          },
          child: buildGrid(widget.width, widget.height)
        );
      },
    );
  }

  Widget buildGrid(int width, int height) {
    List<Widget> rows = [];

    for (int y = 0; y < height; y++) {
      List<Widget> rowChildren = [];
      for (int x = 0; x < width; x++) {
        rowChildren.add(
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: widget.thisLayer!.getColor(y, x),
                  border: Border.all(color: Colors.grey.shade400)),
            ),
          ),
        );
      }
      rows.add(Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: rowChildren,
          )));
    }

    return FractionallySizedBox(
        widthFactor: gridWidthFactor, //for editor page
        heightFactor: gridHeightFactor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: rows,
        ));
  }
}
