import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_editor_app/Cubit/EraseState.dart';

import 'Cubit/PaintState.dart';
import 'Cubit/ColorState.dart';

import 'dart:ui';

class CreateGrid extends StatefulWidget {
  final int width;
  final int height;

  bool selected = false;
  late List<List<Color>> pixelColors; //grid is a multidimensional array

  CreateGrid({
    required this.width,
    required this.height,
    List<List<Color>>? pixelColors,
  }) : pixelColors = pixelColors ?? [];

  @override
  State<CreateGrid> createState() => _CreateGridState();
}

class _CreateGridState extends State<CreateGrid> {
  Offset gridPosition = Offset(0, 0);
  Color defaultColor = Colors.transparent;
  
  double cellSize = 0;
  bool isCreated = false;
  
  late int columns;
  late int rows;
  late int gridSize;

  late PaintCubit paintCubit;
  late ColorCubit colorCubit;
  late EraseCubit eraseCubit;

  late double cellWidth;
  late double cellHeight;

  void _handleGridUpdate(DragUpdateDetails details) {
    setState(() {
      gridPosition += details.delta;
    });
  }

  @override
  void initState() {
    columns = widget.width;
    rows = widget.height;
    gridSize = rows * columns;
    
    paintCubit = BlocProvider.of<PaintCubit>(context);
    colorCubit = BlocProvider.of<ColorCubit>(context); //retieve form state
    eraseCubit = BlocProvider.of<EraseCubit>(context); 
    super.initState();
    if (widget.pixelColors.isEmpty) { // Check if pixelColors is empty
      widget.pixelColors = List.generate(widget.height, (_) => List.filled(widget.width, defaultColor));
    }
  }

  void _calculateGridIndex(Offset localPosition, Color color) {
    final column = (localPosition.dx / cellWidth).floor().clamp(0, columns - 1);
    final row = (localPosition.dy / cellHeight).floor().clamp(0, rows - 1);
    setState(() {
      widget.pixelColors[row][column] = color;
    });
  }

  void _handleClick(Offset localPosition, ColorCubit colorCubit) {
    final column = (localPosition.dx / cellWidth).floor().clamp(0, columns - 1);
    final row = (localPosition.dy / cellHeight).floor().clamp(0, rows - 1);

    setState(() {
      if(colorCubit.state == widget.pixelColors[row][column]){
        widget.pixelColors[row][column] = Colors.transparent;
      } else {
        widget.pixelColors[row][column] = colorCubit.state;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    cellWidth = (screenWidth * 0.4) / widget.width;
    cellHeight = (screenHeight * 0.4) / widget.height;

    if (gridPosition == Offset(0, 0)) {
      gridPosition = Offset(screenWidth * 0.25, screenHeight * 0.25);
    } 

    return Positioned(
      left: gridPosition.dx,
      top: gridPosition.dy,
      child: GestureDetector(
        onTapDown: (details){
          if (paintCubit.state) {
            _handleClick(details.localPosition, colorCubit);
          }
        },
        onPanUpdate: (details) {
          if (paintCubit.state) {
            _calculateGridIndex(details.localPosition, colorCubit.state);
          }
          else if(eraseCubit.state){
            _calculateGridIndex(details.localPosition,Colors.transparent);
          }else if(!widget.selected){
            _handleGridUpdate(details);
          }
        },
        onDoubleTap: (){
          if(!paintCubit.state){
            setState(() {
              widget.selected = !widget.selected;
            });
          }
        },
        child: buildGrid(columns, rows) 
      )
    );
  }

  Widget buildGrid(int width, int height) {
    List<Widget> rows = [];

    for (int y = 0; y < height; y++) {
      List<Widget> rowChildren = [];
      for (int x = 0; x < width; x++) {
        rowChildren.add(
          Container(
            height: cellHeight,
            width: cellWidth,
            decoration: BoxDecoration(
              color: widget.pixelColors[y][x],
              border: Border.all(color: Colors.grey.shade400)
            ),   
          )
        );
      }
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rowChildren,
      ));
    }

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rows,
      )
    );
  }
}