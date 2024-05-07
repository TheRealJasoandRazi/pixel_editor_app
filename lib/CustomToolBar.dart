import 'package:flutter/material.dart';
import 'dart:math';

class CustomToolBar extends StatefulWidget{
    final double screenWidth;
    final double screenHeight;
    final double ypos;

    final List<Widget> toolList = [];
    void add(Widget button){
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
    bool rotatingBar = false; //in thresholds
    bool rotationComplete = false; //done the rotations
    bool draggable = false; //only true when its been rotated and the user stops dragging

    @override
    initState() {
      super.initState();
      toolbarWidth = widget.screenWidth * 0.1;
      toolbarHeight = widget.screenHeight * 0.5;
      toolbarPosition = Offset(0, widget.ypos);
    }

    void _handleToolBarUpdate(DragUpdateDetails details) {
      setState(() {
          if(draggable) {
            //print("up");
            double angle = 0.25; // Determine the angle of rotation
            // Convert delta to radians for trigonometric calculations
            double angleInRadians = angle * 2 * 3.14159;
            // Calculate the rotated delta
            double rotatedDeltaX = details.delta.dx * cos(angleInRadians) - details.delta.dy * sin(angleInRadians);
            double rotatedDeltaY = details.delta.dx * sin(angleInRadians) + details.delta.dy * cos(angleInRadians);
            // Update toolbarPosition with the rotated delta
            toolbarPosition += Offset(rotatedDeltaX, rotatedDeltaY);
          } else if (!draggable) {
            //print("normal");
            toolbarPosition += details.delta;
          }
        
      });
    } 

    Widget _buildResizeHandle({
        required double top,
        required double left,
        required void Function(DragUpdateDetails) onPanUpdate,
        required bool vertical,
        required double toolbarWidth,
        required double toolbarHeight
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
                  color: Colors.grey.shade400, //makes it invisible
                  borderRadius: BorderRadius.circular(16.0),
                ),
            ),
          ),
        );
    }

    @override
    Widget build(BuildContext context) {

      final double minWidth = widget.screenWidth * 0.05;// Minimum width
      final double maxWidth = widget.screenWidth * 0.2; // Maximum width
      final double minHeight = widget.screenHeight * 0.3; // Minimum height
      final double maxHeight = widget.screenHeight * 0.6; // Maximum height

      double threshold = widget.screenHeight * 0.05;
      double lowerThreshold = widget.screenHeight - threshold - toolbarHeight;

      if(toolbarPosition.dy <= threshold || toolbarPosition.dy >= lowerThreshold)
      {
        rotatingBar = true;
      } else {
        rotatingBar = false;
      }

      return Positioned(
        left: toolbarPosition.dx,
        top: toolbarPosition.dy,
        child: AnimatedRotation(
          turns: rotatingBar ? 0.25 : 0,
          duration: Duration(milliseconds: 300),
          alignment: Alignment.center,
          curve: Curves.easeInOut,
          onEnd: () {
            setState(() {
              if(rotatingBar)
              {
                rotationComplete = true;
              }
              else
              {
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
                if(rotationComplete){ //fixes transitioning into rotation
                  draggable = true;
                } else {
                  draggable = false;
                }
              });
            },
          child: Container( //the toolbar itself
              width: toolbarWidth,
              height: toolbarHeight,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: Colors.grey[400],
              ),
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
                            child: AnimatedRotation(
                              turns: rotatingBar ? -0.25 : 0,
                              duration: Duration(milliseconds: 600),
                              curve: Curves.easeInOut,
                              child: tool,
                            )
                          );
                        }).toList(),
                      ],
                  ),
                ),
                _buildResizeHandle( //left side
                  top: 0,
                  left: 0, 
                  onPanUpdate:(details) {
                    setState(() {
                      double newWidth = toolbarWidth - details.delta.dx; //get difference
                      toolbarWidth = newWidth.clamp(minWidth, maxWidth); 
                      toolbarPosition = Offset(toolbarPosition.dx + details.delta.dx, toolbarPosition.dy);
                    });
                  },
                  vertical: true, 
                  toolbarWidth: toolbarWidth, 
                  toolbarHeight: toolbarHeight),
                
                _buildResizeHandle( // right side 
                  top: 0,
                  left: toolbarWidth - 10, // Place it at the right side
                  onPanUpdate: (details) {
                      setState(() {
                          double newWidth = toolbarWidth + details.delta.dx;
                          toolbarWidth = newWidth.clamp(minWidth, maxWidth);
                      });
                  },
                  vertical: true,
                  toolbarWidth: toolbarWidth,
                  toolbarHeight: toolbarHeight,
                ),
                // Top resize handle
                _buildResizeHandle(
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
                  toolbarWidth: toolbarWidth,
                  toolbarHeight: toolbarHeight,
                ),
                // Bottom resize handle
                _buildResizeHandle(
                  top: toolbarHeight - 10, // Place at bottom of toolbar
                  left: 0,
                  onPanUpdate: (details) {
                      setState(() {
                          double newHeight = toolbarHeight + details.delta.dy;
                          toolbarHeight = newHeight.clamp(minHeight, maxHeight);
                      });
                  },
                  vertical: false,
                  toolbarWidth: toolbarWidth,
                  toolbarHeight: toolbarHeight,
                ),
              ],)
            ),
          )
        )
      );       
    }
}
