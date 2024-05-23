import 'package:flutter/material.dart';
import 'dart:math';

import 'package:pixel_editor_app/Cubit/RotatedToolBarState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomToolBar extends StatefulWidget {
  final double screenWidth;
  final double screenHeight;
  final double ypos;
  final List<Widget> toolList = [];

  void add(Widget button) {
    toolList.add(button);
  }

  CustomToolBar({
    required this.screenWidth,
    required this.screenHeight,
    required this.ypos,
  });

  @override
  _CustomToolBarState createState() => _CustomToolBarState();
}

class _CustomToolBarState extends State<CustomToolBar> {
  late double toolbarWidth;
  late double toolbarHeight;
  Offset toolbarPosition = Offset.zero;
  bool rotationComplete = false; // done the rotations
  bool draggable = false; // only true when its been rotated and the user stops dragging

  @override
  initState() {
    super.initState();
    toolbarWidth = widget.screenWidth * 0.1;
    toolbarHeight = widget.screenHeight * 0.5;
    toolbarPosition = Offset(0, widget.ypos);
  }

  void _handleToolBarUpdate(DragUpdateDetails details) { //temporarily made it so it only moves vertically
    setState(() {
      if (draggable) {
        double angle = 0.25; // Determine the angle of rotation
        double angleInRadians = angle * 2 * pi;
        double rotatedDeltaX = details.delta.dx * cos(angleInRadians) - details.delta.dy * sin(angleInRadians);
        double rotatedDeltaY = details.delta.dx * sin(angleInRadians) + details.delta.dy * cos(angleInRadians);
        toolbarPosition += Offset(rotatedDeltaX, rotatedDeltaY);
      } else {
        Offset newToolBarPosition = (toolbarPosition + Offset(0, details.delta.dy));
        if(newToolBarPosition.dy > 0 && newToolBarPosition.dy < (widget.screenHeight - toolbarHeight)){
          toolbarPosition += Offset(0, details.delta.dy);
        }
      }
    });
  }

  Widget _buildResizeHandle({
    required double top, //position of the handle
    required double left, //position of the handle
    required void Function(DragUpdateDetails) onPanUpdate,
    required bool vertical,
  }) {
    return Positioned(
      top: top,
      left: left,
      child: GestureDetector(
        onPanUpdate: onPanUpdate,
        child: Container(
          width: vertical ? 10 : toolbarWidth,
          height: vertical ? toolbarHeight : 10,
          decoration: BoxDecoration(
            color: Colors.transparent, // makes it invisible
          ),
          child: vertical
            ? Column(
              crossAxisAlignment: CrossAxisAlignment.end,
                // If vertical is true, use Column
                children: [
                  Expanded(
                    child: FractionallySizedBox(
                      widthFactor: 0.3,
                      heightFactor: 0.9,
                      child: Container(
                        color: Colors.black,
                    
                      )
                    ),
                  )            
                ],
              )
            : Row(
                // If vertical is false, use Row
                children: [
                  Expanded(    
                    child: FractionallySizedBox(
                      widthFactor: 0.8,
                      heightFactor: 0.3,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          color: Colors.black, 
                        ),
                      ),
                    )
                  )
                ],
              ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double minWidth = widget.screenWidth * 0.05; // Minimum width
    final double maxWidth = widget.screenWidth * 0.2; // Maximum width
    final double minHeight = widget.screenHeight * 0.3; // Minimum height
    final double maxHeight = widget.screenHeight * 0.6; // Maximum height

    double threshold = widget.screenHeight * 0.05;
    double lowerThreshold = widget.screenHeight - threshold - toolbarHeight;

    final rotatedToolBarCubit = BlocProvider.of<RotatedToolBarCubit>(context);

    bool shouldRotateBar = toolbarPosition.dy <= threshold || toolbarPosition.dy >= lowerThreshold;

    if (shouldRotateBar != rotatedToolBarCubit.state) {
      //temporarily made it move only vertically
      //rotatedToolBarCubit.changeState(shouldRotateBar); 
    }

    return Positioned(
      left: toolbarPosition.dx,
      top: toolbarPosition.dy,
      child: AnimatedRotation(
        turns: rotatedToolBarCubit.state ? 0.25 : 0,
        duration: Duration(milliseconds: 300),
        alignment: Alignment.center,
        curve: Curves.easeInOut,
        onEnd: () {
          setState(() {
            if (rotatedToolBarCubit.state) {
              rotationComplete = true;
            } else {
              rotationComplete = false;
            }
          });
        },
        child: GestureDetector(
          onPanUpdate: (details) {
            setState(() {
              _handleToolBarUpdate(details);
            });
          },
          onPanEnd: (details) {
            setState(() {
              if (rotationComplete) {
                draggable = true;
              } else {
                draggable = false;
              }
            });
          },
          child: Container( //gives smoothness when changing sizes
            width: toolbarWidth,
            height: toolbarHeight,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.grey[400],
            ),
            child: ClipRect( //makes it so it doesn't clip through the container
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ...widget.toolList.map((tool) {
                          return Flexible(
                            flex: 1,
                            child: tool,
                          );
                        }).toList(),
                      ],
                    )
                  ),
                  /*_buildResizeHandle( //left vertical
                    top: 0,
                    left: 0,
                    onPanUpdate: (details) {
                      setState(() {
                        double newWidth = toolbarWidth - details.delta.dx;
                        toolbarWidth = newWidth.clamp(minWidth, maxWidth); //ensure it stays within the constraints
                        toolbarPosition = Offset(toolbarPosition.dx + details.delta.dx, toolbarPosition.dy);
                      });
                    },
                    vertical: true,
                  ),*/
                  _buildResizeHandle( //right vertical
                    top: 0,
                    left: toolbarWidth - 10,
                    onPanUpdate: (details) {
                      setState(() {
                        double newWidth = toolbarWidth + details.delta.dx;
                        toolbarWidth = newWidth.clamp(minWidth, maxWidth);
                      });
                    },
                    vertical: true,
                  ),
                  /*_buildResizeHandle( //top of toolbar
                    top: 0,
                    left: 0,
                    onPanUpdate: (details) {
                      setState(() {
                        double newHeight = toolbarHeight - details.delta.dy;
                        toolbarHeight = newHeight.clamp(minHeight, maxHeight);
                        toolbarPosition += Offset(0, details.delta.dy);
                      });
                    },
                    vertical: false,
                  ),*/
                  _buildResizeHandle( //bottom of toolbar
                    top: toolbarHeight - 10,
                    left: 0,
                    onPanUpdate: (details) {
                      setState(() {
                        double newHeight = toolbarHeight + details.delta.dy;
                        toolbarHeight = newHeight.clamp(minHeight, maxHeight);
                      });
                    },
                    vertical: false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
