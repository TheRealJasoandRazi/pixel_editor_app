import 'package:flutter/material.dart';
import 'dart:typed_data';

class ImageWrapper extends StatefulWidget {
  final Uint8List? image;

  const ImageWrapper({
    required this.image,
    super.key,
  });

  @override
  _ImageWrapperState createState() => _ImageWrapperState();
}

class _ImageWrapperState extends State<ImageWrapper> {
  Offset wrapperPosition = Offset(0, 0);
  double size = 0;

  void _handleFormUpdate(DragUpdateDetails details) {
    setState(() {
      wrapperPosition += details.delta;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if(size == 0){
       size = screenWidth / 2;
    }

    if (wrapperPosition == Offset(0, 0)) {
      // Initialize form location
      wrapperPosition = Offset(screenWidth / 2, screenWidth / 2);
    }

      return Stack( //stack to add future widgets on top
      children: [
        Positioned(
          left: wrapperPosition.dx + size,
          top: wrapperPosition.dy - 10,
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
          left: wrapperPosition.dx,
          top: wrapperPosition.dy,
          child: GestureDetector(
            onPanUpdate: _handleFormUpdate,
            child: Container(
              width: size,
              height: size,
              child: widget.image != null ? Image.memory(widget.image!) : Placeholder(),
            ),
          ),
        )
      ]
    );
  }
}
