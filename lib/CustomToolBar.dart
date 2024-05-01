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
    Offset toolbarPosition = Offset.zero;
    bool rotatingBar = false; //in thresholds
    bool rotationComplete = false; //done the rotations
    bool draggable = false; //only true when its been rotated and the user stops dragging

    @override
    initState() {
      super.initState();
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

    @override
    Widget build(BuildContext context) {
      double width = widget.screenWidth * 0.1;
      double height = widget.screenHeight * 0.5;

      double threshold = widget.screenHeight * 0.05;
      double lowerThreshold = widget.screenHeight - threshold - height;

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
                  curve: Curves.easeInOut,
                  onEnd: () {
                    setState(() {
                      rotationComplete = !rotationComplete;
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
                    
                    child: Container(
                        width: width,
                        height: height,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: Colors.grey[400],
                        ),
                        child: Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                   ...widget.toolList.map((tool) {
                                    return AnimatedRotation(
                                      turns: rotatingBar ? -0.25 : 0,
                                      duration: Duration(milliseconds: 600),
                                      curve: Curves.easeInOut,
                                      child: tool,
                                    );
                                  }).toList(),
                                ],
                            ),
                        ),
                    ),
                ),
            ),
        );
    }
}
