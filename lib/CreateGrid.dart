import 'package:flutter/material.dart';
import 'GridItem.dart';

import 'Cubit/PaintState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CreateGrid extends StatefulWidget {
  int width;
  int height;

  CreateGrid({
    required this.width,
    required this.height,
  });

  @override
  State<CreateGrid> createState() => _CreateGridState();
}

class _CreateGridState extends State<CreateGrid> {
  Offset gridPosition = Offset(0,0);

  void _handleGridUpdate(DragUpdateDetails details) {
    setState(() {
      gridPosition += details.delta;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if(gridPosition == Offset(0,0)){//initialise form location
      gridPosition = Offset(screenWidth/2, screenWidth/2);
    }

    final paintCubit = BlocProvider.of<PaintCubit>(context); //retieve form state

    return Positioned(
      left: gridPosition.dx,
      top: gridPosition.dy,
      child: GestureDetector(
        onPanUpdate:(details) {
          if(!paintCubit.state) 
            _handleGridUpdate(details);
        },
          child: Container(
          width: screenWidth / 2,
          height: screenHeight / 2, 
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.width, // Number of columns in the grid
                childAspectRatio: 1, // Aspect ratio of each grid item (square boxes)
            ),
            itemCount: widget.height * widget.width,
            physics: NeverScrollableScrollPhysics(), //prevents scrolling
            itemBuilder: (context, index) {
              return GridItem(index: index);
            },
          ),
        ),
      ),
    );
  }
}