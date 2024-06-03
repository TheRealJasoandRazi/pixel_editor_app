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

  CreateGrid({
    required this.width,
    required this.height,
    List<List<Color>>? pixelColors,
  }) : pixelColors = pixelColors ?? []; // Initialize pixelColors with an empty list if not provided

  @override
  State<CreateGrid> createState() => _CreateGridState();
}

class _CreateGridState extends State<CreateGrid> {
  Offset gridPosition = Offset(0, 0);
  //List<List<Color>> widget.pixelColors = []; //grid is a multidimensional array
  Color defaultColor = Colors.transparent;

  double size = 0;

  bool isCreated = false;

  late PaintCubit paintCubit;
  late ColorCubit colorCubit;
  late EraseCubit eraseCubit;

  @override
  void initState() {
    paintCubit = BlocProvider.of<PaintCubit>(context);
    colorCubit = BlocProvider.of<ColorCubit>(context); //retieve form state
    eraseCubit = BlocProvider.of<EraseCubit>(context); 
    super.initState();
    if (widget.pixelColors.isEmpty) { // Check if pixelColors is empty
      widget.pixelColors = List.generate(widget.height, (_) => List.filled(widget.width, defaultColor));
    }
  }

  @override
  void dispose(){
    super.dispose();
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
      widget.pixelColors[row][column] = color;
    });
  }

  void _handleClick(int row, int column, ColorCubit colorCubit) {
    setState(() {
      if(colorCubit.state == widget.pixelColors[row][column]){
        widget.pixelColors[row][column] = Colors.transparent;
      } else {
        widget.pixelColors[row][column] = colorCubit.state;
      }
    });
  }

  Widget grid() {    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: widget.selected ? Border.all(color: Colors.blue, width: 2.0) : Border.all(color: Colors.transparent),
      ),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.width,
        ),
        itemCount: widget.width * widget.height,
        itemBuilder: (context, index) {
          int rowIndex = index ~/ widget.width;
          int columnIndex = index % widget.width;
          //progressCubit.updateProgress(index/(widget.width * widget.height), "Creating Grid...", true); //update progress bar
          Color color = widget.pixelColors[rowIndex][columnIndex];

          //if(index == widget.width * widget.height - 1){progressCubit.updateProgress(0, "", false);}
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
      )
    );
  }

  Future<Widget> futureGrid() async {
    return grid();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if(size == 0){
       size = screenWidth / 2;
    }

    if (gridPosition == Offset(0, 0)) {
      gridPosition = Offset(screenWidth / 2, screenHeight / 2);
    }

    final progressCubit = BlocProvider.of<ProgressCubit>(context); 

    return Stack( //stack to add future widgets on top
      children: [
        Positioned(
          left: gridPosition.dx + size,
          top: gridPosition.dy - 10,
          child: GestureDetector( //adjusts size of grid
            onPanUpdate: (details) {
              setState(() { 
                size += details.delta.dx; 
                size = size.clamp(screenWidth * 0.15, screenWidth * 0.80); //add constraints
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
            onPanUpdate: (details) {
              if (paintCubit.state) {
                _calculateGridIndex(details.localPosition, size, colorCubit.state);
              }
              else if(eraseCubit.state){
                _calculateGridIndex(details.localPosition, size, Colors.transparent);
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
            child: isCreated ? grid() 
            : FutureBuilder<Widget>(
              future: futureGrid(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Creating Grid",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          CircularProgressIndicator(),
                        ],
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
          ),
        )
      ]
    );
  }
}
