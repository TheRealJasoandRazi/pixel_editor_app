import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

class ImageWrapper extends StatefulWidget {
  final Uint8List? image;
  final double width;
  final double height;

  bool selected = false;

  ImageWrapper({
    required this.image,
    required this.width,
    required this.height,
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
  void dispose(){
    super.dispose();
  }

  late double imageWidth;
  late double imageHeight;

  @override
  void initState() {
    super.initState();
    imageWidth = widget.width;
    imageHeight = widget.height;
  }



  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (wrapperPosition == Offset(0, 0)) {
      // Initialize form location
      wrapperPosition = Offset(screenWidth / 2, screenWidth / 2);
    }

      return Stack( //stack to add future widgets on top
      children: [
        Positioned(
          left: wrapperPosition.dx + imageWidth!,
          top: wrapperPosition.dy - 10,
          child: GestureDetector( //adjusts size of grid
            onPanUpdate: (details) {
              setState(() { 
                imageWidth = (imageWidth + details.delta.dx).clamp(screenWidth * 0.15, screenWidth * 0.80);
                imageHeight = (imageHeight + details.delta.dy).clamp(screenHeight * 0.15, screenHeight * 0.80);
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
            onDoubleTap: (){
              setState(() {
                widget.selected = !widget.selected;
              });
            },
            child: Container(
              width: imageWidth,
              height: imageHeight,
              decoration: BoxDecoration(
                border: widget.selected ? Border.all(color: Colors.blue, width: 2.0) : Border.all(color: Colors.transparent),
              ),
              child: widget.image != null
                  ? Image.memory(
                      widget.image!,
                      fit: BoxFit.fill, // Force the image to fill the container
                    )
                  : Placeholder(),
            ),
          ),
        )
      ]
    );
  }
}
