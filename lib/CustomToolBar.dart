import 'package:flutter/material.dart';

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
                                   ...widget.toolList.map((tool) {
                                    return AnimatedRotation(
                                      turns: rotatedBar ? -0.25 : 0,
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
