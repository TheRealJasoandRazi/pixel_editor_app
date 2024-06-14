import 'package:flutter/material.dart';
import 'dart:math';
import 'Cubit/ColorState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'Cubit/ColorWheelState.dart';

class ColorWheel extends StatefulWidget {
  const ColorWheel({Key? key}) : super(key: key);

  @override
  _ColorWheelState createState() => _ColorWheelState();
}

class _ColorWheelState extends State<ColorWheel> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  bool _isSidebarVisible = false;

  late Color selectedColor;
  double angle = 0.0;
  double tone = 0.0;
  double tint = 0.0;
  double shade = 0.0;

  final double baseSaturation = 1.0;
  final double baseLightness = 0.5;

  late final ColorCubit colorCubit;
  late final ColorWheelCubit colorWheelCubit;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(-0.9, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    colorCubit = context.read<ColorCubit>();
    colorWheelCubit = context.read<ColorWheelCubit>();
  }

  void _toggleSidebar() {
    setState(() {
      colorWheelCubit.toggleColorWheel();
      _isSidebarVisible = !_isSidebarVisible;
      if (_isSidebarVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget colorWheel(double width, double height) {
    double finalSaturation =
        (baseSaturation * (1.0 - tone * 0.5 + shade * 0.5 - tint * 0.5)).clamp(0.0, 1.0);
    double finalLightness =
        (baseLightness * (1.0 - tone * 0.5 - shade * 0.5 + tint * 0.5)).clamp(0.0, 1.0);
    selectedColor = HSLColor.fromAHSL(1, angle, finalSaturation, finalLightness).toColor();
    colorCubit.changeColor(selectedColor); // Update color in the bloc

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 5,
          child: GestureDetector(
            onPanUpdate: (details) {
              final box = context.findRenderObject() as RenderBox;
              final offset = box.globalToLocal(details.globalPosition);
              final size = box.size;
              final center = Offset(size.width / 2, size.height / 2);
              final dx = offset.dx - center.dx;
              final dy = offset.dy - center.dy;
              angle = (atan2(dy, dx) * 180 / pi + 360) % 360;
              setState(() {
                selectedColor =
                    HSLColor.fromAHSL(1, angle, finalSaturation, finalLightness).toColor();
              });
            },
            child: CustomPaint(
              size: Size(width * 0.8, height * 0.8),
              painter: ColorWheelPainter(
                saturation: finalSaturation,
                lightness: finalLightness,
              ),
            ),
          )
        ),
        Expanded(
          flex: 1,
          child: Container(
            width: width * 0.5,
            height: height * 0.1,
            color: selectedColor,
          )
        ),
        Expanded(
          flex: 1,
          child: Text("Tone")
        ),
        Expanded(
          flex: 2,
          child: Slider(
            value: tone,
            min: 0.0,
            max: 1.0,
            onChanged: (newValue) {
              setState(() {
                tone = newValue;
              });
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Text("Tint"),
        ),
        Expanded(
          flex: 2,
          child: Slider(
            value: tint,
            min: 0.0,
            max: 1.0,
            onChanged: (newValue) {
              setState(() {
                tint = newValue;
              });
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: Text("Shade"),
        ),
        Expanded(
          flex: 2,
          child: Slider(
            value: shade,
            min: 0.0,
            max: 1.0,
            onChanged: (newValue) {
              setState(() {
                shade = newValue;
              });
            },
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
        child: SlideTransition(
        position: _offsetAnimation,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(12.0),
              bottomRight: Radius.circular(12.0),
            ),
            color: Colors.deepPurple,
          ),
          width: 300,
          height: 500,
          child: Stack(
            children: [
              colorWheel(300, 500),
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: _toggleSidebar,
                  child: Icon(Icons.outbond),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//INCASE OF A FUTURE UPDATE
/*
newR = currentR * (1 - shade_factor)
newG = currentG * (1 - shade_factor)
newB = currentB * (1 - shade_factor)

newR = currentR + (255 - currentR) * tint_factor
newG = currentG + (255 - currentG) * tint_factor
newB = currentB + (255 - currentB) * tint_factor

nothing for tone, i guess tint factor but weaker?
*/
class ColorWheelPainter extends CustomPainter {
  final double saturation;
  final double lightness;
  final double increment;

  ColorWheelPainter({required this.saturation, required this.lightness, this.increment = 0.5});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = min(size.width, size.height) / 2;
    final center = Offset(size.width / 2, size.height / 2);

    for (double angle = 0; angle < 360; angle += increment) {
      final x = center.dx + radius * cos(angle * pi / 180);
      final y = center.dy + radius * sin(angle * pi / 180);
      final paint = Paint()
        ..shader = SweepGradient(
          colors: [
            HSLColor.fromAHSL(1, angle, saturation, lightness).toColor(),
            HSLColor.fromAHSL(1, angle + increment, saturation, lightness).toColor(),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius));
      canvas.drawLine(center, Offset(x, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}