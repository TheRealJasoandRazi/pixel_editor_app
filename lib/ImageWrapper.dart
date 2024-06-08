import 'package:flutter/material.dart';
import 'dart:typed_data';

import 'package:pixel_editor_app/Cubit/ImageListState.dart';

class ImageWrapper extends StatefulWidget {
  final Uint8List image;
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

class _ImageWrapperState extends State<ImageWrapper> with SingleTickerProviderStateMixin {
  Offset wrapperPosition = Offset(0, 0);
  double size = 0;
  bool showInfo = false;

  late AnimationController _controller;
  late Animation<int> _typewriterAnimation;
  final String infoOutput = "Use the pixelate tool to transform the image into a grid";

  void _handleFormUpdate(DragUpdateDetails details) {
    setState(() {
      wrapperPosition += details.delta;
    });
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  late double imageWidth;
  late double imageHeight;

  @override
  void initState() {
    super.initState();
    imageWidth = widget.width;
    imageHeight = widget.height;

    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _typewriterAnimation = IntTween(begin: 0, end: infoOutput.length).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        setState(() {
          showInfo = false;
        });
      }
    });
  }

  void _toggleInfo() {
    if (!showInfo) {
      setState(() {
        showInfo = true;
      });
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (wrapperPosition == Offset(0, 0)) {
      // Initialize form location
      wrapperPosition = Offset(screenWidth * 0.25, screenWidth * 0.25);
    }

    return Stack(
      children: [
        Positioned(
          left: wrapperPosition.dx + imageWidth,
          top: wrapperPosition.dy - 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onPanUpdate: (details) {
                  setState(() { 
                    imageWidth = (imageWidth + details.delta.dx).clamp(screenWidth * 0.15, screenWidth * 0.80);
                    imageHeight = (imageHeight + details.delta.dy).clamp(screenHeight * 0.15, screenHeight * 0.80);
                  }); 
                },
                child: Icon(Icons.arrow_outward),
              ),
              GestureDetector(
                onTap: _toggleInfo,
                child: Icon(
                  color: showInfo ? Colors.blue : Colors.black,
                  Icons.info
                ),
              ),
              if (showInfo)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                    ),
                  ),
                  padding: EdgeInsets.all(8.0),
                  child: Center(
                    child: AnimatedBuilder(
                      animation: _typewriterAnimation,
                      builder: (BuildContext context, Widget? child) {
                        return Text(
                          infoOutput.substring(0, _typewriterAnimation.value),
                        );
                      },
                    ),
                  ),
                )
            ],
          ),
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
              child: Image.memory(
                widget.image,
                fit: BoxFit.fill, // Force the image to fill the container
              )
            ),
          ),
        )
      ]
    );
  }
}
