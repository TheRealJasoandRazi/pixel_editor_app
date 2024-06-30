import 'package:flutter/material.dart';

class ToolTipPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.1) // starts at 10% down from the top-left corner
      ..lineTo(size.width * 0.1, 0) // moves up to 10% across the top
      ..lineTo(size.width * 0.9, 0) // moves across to 90% of the width
      ..lineTo(size.width, size.height * 0.1) // moves down to 10% of the height
      ..lineTo(size.width, size.height * 0.9) // moves down to 90% of the height
      ..lineTo(size.width * 0.9, size.height) // moves to the bottom-right corner
      ..lineTo(size.width * 0.6, size.height) // moves left to 60% of the width
      ..lineTo(size.width * 0.4, size.height * 1.2) // creates the right side of the arrow pointing down
      ..lineTo(size.width * 0.4, size.height) // connects back to the bottom at 40% of the width
      ..lineTo(size.width * 0.1, size.height) // moves left to 10% of the width
      ..lineTo(0, size.height * 0.9) // moves up to 90% of the height
      ..close(); // closes the path

    canvas.drawShadow(path, Colors.black, 4.0, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

}