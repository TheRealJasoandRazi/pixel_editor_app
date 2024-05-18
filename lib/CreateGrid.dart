import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Cubit/PaintState.dart';
import 'Cubit/ColorState.dart';

class CreateGrid extends StatefulWidget {
  final int width;
  final int height;

  CreateGrid({
    required this.width,
    required this.height,
  });

  @override
  State<CreateGrid> createState() => _CreateGridState();
}

class _CreateGridState extends State<CreateGrid> {
  Offset gridPosition = Offset(0, 0);
  List<List<Color>> pixelColors = []; //grid is a multidimensional array
  Color defaultColor = Colors.transparent;

  @override
  void initState() {
    super.initState();
    pixelColors = List.generate(widget.height, (_) => List.filled(widget.width, defaultColor));
  }

  void _handleGridUpdate(DragUpdateDetails details) {
    setState(() {
      gridPosition += details.delta;
    });
  }

  void _calculateGridIndex(Offset localPosition, double size, Color color) {
    final int rows = widget.height;
    final int columns = widget.width;
    
    final cellWidth = size / columns;
    final cellHeight = size / rows;

    final column = (localPosition.dx / cellWidth).floor().clamp(0, columns - 1);
    final row = (localPosition.dy / cellHeight).floor().clamp(0, rows - 1);

    setState(() {
      pixelColors[row][column] = color;
    });
  }

  void _handleClick(int row, int column, ColorCubit colorCubit) {
    setState(() {
      if(colorCubit.state == pixelColors[row][column]){
        pixelColors[row][column] = Colors.transparent;
      } else {
        pixelColors[row][column] = colorCubit.state;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final size = screenWidth / 2;

    if (gridPosition == Offset(0, 0)) {
      gridPosition = Offset(screenWidth / 2, screenHeight / 2);
    }

    final paintCubit = BlocProvider.of<PaintCubit>(context);
    final colorCubit = BlocProvider.of<ColorCubit>(context); //retieve form state

    return Positioned(
      left: gridPosition.dx,
      top: gridPosition.dy,
      child: GestureDetector(
        onPanUpdate: (details) {
          if (paintCubit.state) {
            RenderBox renderBox = context.findRenderObject() as RenderBox;
            Offset localPosition = renderBox.globalToLocal(details.globalPosition);
            _calculateGridIndex(localPosition, size, colorCubit.state);
          } else {
            _handleGridUpdate(details);
          }
        },
        child: Container(
          width: size,
          height: size,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.width,
            ),
            itemCount: widget.width * widget.height,
            itemBuilder: (context, index) {
              int rowIndex = index ~/ widget.width;
              int columnIndex = index % widget.width;

              Color color = pixelColors[rowIndex][columnIndex];

              return GestureDetector(
                onTap: () {
                  if (paintCubit.state) {
                    _handleClick(rowIndex, columnIndex, colorCubit);
                  }
                },
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    color: color,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
