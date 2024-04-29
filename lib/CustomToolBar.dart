import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'PaintTool.dart';

class CustomToolBar extends StatefulWidget {
    final double screenWidth;
    final double screenHeight;
    final double ypos;
    final Function() toggleFormVisibility;

    CustomToolBar({
        required this.screenWidth,
        required this.screenHeight,
        required this.ypos,
        required this.toggleFormVisibility,
    });

    @override
    _CustomToolBarState createState() => _CustomToolBarState();
}

class _CustomToolBarState extends State<CustomToolBar> {
    Offset toolbarPosition = Offset.zero;

    @override
    initState() {
      super.initState();
      toolbarPosition = Offset(0, widget.ypos);
    }

    void _handleToolBarUpdate(DragUpdateDetails details) {
      setState(() {
        toolbarPosition += details.delta;
      });
    }

    Widget toolBarButton(IconData icon, Function() action, Color color) {
        return Flexible(
            flex: 1,
            child: FractionallySizedBox(
                widthFactor: 0.75,
                heightFactor: 0.2,
                child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: color,
                            boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                ),
                            ],
                        ),
                        child: GestureDetector(
                            onTap: action,
                            child: Icon(
                                icon,
                            ),
                        ),
                    ),
                ),
            ),
        );
    }

    @override
    Widget build(BuildContext context) {
      double width = widget.screenWidth * 0.1;
      double height = widget.screenHeight * 0.5;

      double threshold = widget.screenHeight * 0.05;
      double lowerThreshold = widget.screenHeight - threshold - height;
      bool rotatedBar = false;

      if(toolbarPosition.dy <= threshold || toolbarPosition.dy >= lowerThreshold)
      {
        rotatedBar = true;
      } else {
        rotatedBar = false;
      }

        return Positioned(
            left: toolbarPosition.dx,
            top: toolbarPosition.dy,
            child: GestureDetector(
                onPanUpdate: _handleToolBarUpdate,
                child: AnimatedRotation(
                    turns: rotatedBar ? 0.25 : 0, 
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
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
                                    toolBarButton(Icons.grid_on, widget.toggleFormVisibility, Colors.grey.shade300),
                                    PaintTool()
                                ],
                            ),
                        ),
                    ),
                ),
            ),
        );
    }
}
