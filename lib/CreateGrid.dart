import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_editor_app/Cubit/EraseState.dart';

import 'Cubit/PaintState.dart';
import 'Cubit/ColorState.dart';
import 'Cubit/ProgressState.dart';

import 'dart:ui';

class CreateGrid extends StatefulWidget {
  final int width;
  final int height;

  bool selected = false;
  late List<List<Color>> pixelColors; //grid is a multidimensional array
  late bool export;

  CreateGrid({
    required this.width,
    required this.height,
    List<List<Color>>? pixelColors,
    bool? export,
  }) : pixelColors = pixelColors ?? [],
        export = export ?? false;

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

  @override
  void initState() {
    columns = widget.width;
    rows = widget.height;
    gridSize = rows * columns;
   /* if(columns >= rows){
      cellSize = 100 / columns; //default size is 100 pixels
    } else{
      cellSize = 100 / rows;
    }*/
    
    print(cellSize);
    paintCubit = BlocProvider.of<PaintCubit>(context);
    colorCubit = BlocProvider.of<ColorCubit>(context); //retieve form state
    eraseCubit = BlocProvider.of<EraseCubit>(context); 
    super.initState();
    if (widget.pixelColors.isEmpty) { // Check if pixelColors is empty
      widget.pixelColors = List.generate(widget.height, (_) => List.filled(widget.width, defaultColor));
    }
  }

  void _handleGridUpdate(DragUpdateDetails details) {
    setState(() {
      gridPosition += details.delta;
    });
  }

  void _calculateGridIndex(Offset localPosition, Color color) {
    final column = (localPosition.dx / cellSize).floor().clamp(0, columns - 1);
    final row = (localPosition.dy / cellSize).floor().clamp(0, rows - 1);
    setState(() {
      widget.pixelColors[row][column] = color;
    });
  }

  void _handleClick(Offset localPosition, ColorCubit colorCubit) {
    final column = (localPosition.dx / cellSize).floor().clamp(0, columns - 1);
    final row = (localPosition.dy / cellSize).floor().clamp(0, rows - 1);

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

    if (gridPosition == Offset(0, 0)) {
      gridPosition = Offset(screenWidth / 2, screenHeight / 2);
    } 

    if(cellSize == 0){
      if(columns >= rows){
        cellSize = (screenWidth * 0.25) / columns; //default size is 100 pixels
      } else{
        cellSize = (screenWidth * 0.25) / rows;
      }
    }

    return Stack( //stack to add future widgets on top
      children: [
        Positioned(
          left: gridPosition.dx + (cellSize * widget.width),
          top: gridPosition.dy - 10,
          child: GestureDetector( //adjusts size of grid
            onPanUpdate: (details) {
              setState(() { 
                double adjustmentFactor = 1 / (columns * rows).toDouble();
                cellSize += (details.delta.dx / adjustmentFactor);
                double lowerThreshold = rows >= columns ? (screenWidth * 0.15)  / rows : (screenWidth * 0.15) / columns;
                double upperThreshold = rows >= columns ? (screenWidth * 0.8) / rows : (screenWidth * 0.8) / columns;
                cellSize = cellSize.clamp(lowerThreshold, upperThreshold); //add constraints
              }); 
            },
            child: Icon(
              Icons.arrow_outward
            ),
          )
        ),
        Positioned(
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
              }
              else if(!widget.selected){
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
            child: isCreated ? buildGrid(columns, rows) 
            : FutureBuilder<Widget>(
              future: futureGrid(columns, rows),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: cellSize * columns,
                    height: cellSize * rows,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400
                    ),
                    child: Center(
                      child: Text(
                        "Creating Grid",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),               
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  isCreated = true;
                  return Container(child: snapshot.data);
                }
              },
            ),
          )
        )
      ]
    );
  }

  Future<Widget> futureGrid(int width, int height) async {
    return buildGrid(width, height);
  }

  Widget buildGrid(int width, int height) {
    List<Widget> rows = [];

    for (int y = 0; y < height; y++) {
      List<Widget> rowChildren = [];
      for (int x = 0; x < width; x++) {
        rowChildren.add(
          Container(
            height: cellSize,
            width: cellSize,
            decoration: BoxDecoration(
              color: widget.pixelColors[y][x],
              border: widget.export ? null : Border.all(color: Colors.grey.shade400)
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
      decoration: BoxDecoration( //border causes error
       border: (widget.selected && !widget.export) ? Border.all(color: Colors.blue) : null,
      ),          
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rows,
      )
    );
  }
}