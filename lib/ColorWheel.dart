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

  late Color selectedColor;
  double angle = 0.0;
  /*double tone = 0.0;
  double tint = 0.0;
  double shade = 0.0;*/

  bool firstPage = true;

  double saturation = 1.0;
  double lightness = 0.5;

  Color? currentColor; //for list selection

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
      if (colorWheelCubit.state) {
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 10,
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        firstPage = true;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: firstPage ? Colors.blue : Colors.grey,
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      child: Center(
                        child: Text(
                          "Wheel",
                          style: TextStyle(
                            color: firstPage ? Colors.white : Colors.black,
                          ),
                        )
                      )
                    ),
                  )
                ),
                Expanded(
                  flex: 1,
                  child: Container()
                ),
                Expanded(
                  flex: 10,
                  child: GestureDetector(
                    onTap: (){
                      setState(() {
                        firstPage = false;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: firstPage ? Colors.grey : Colors.blue,
                        borderRadius: BorderRadius.all(Radius.circular(16.0)),
                      ),
                      child: Center(
                        child: Text(
                          "List",
                          style: TextStyle(
                            color: firstPage ? Colors.black : Colors.white,
                          ),
                        )
                      )
                    )
                  )
                )
              ],
            )
          ),
        ),
        if (firstPage)
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
                setState(() {
                  angle = (atan2(dy, dx) * 180 / pi + 360) % 360;
                  selectedColor = HSLColor.fromAHSL(1, angle, saturation, lightness).toColor();
                  colorCubit.changeColor(selectedColor);
                });
              },
              child: CustomPaint(
                size: Size(width * 0.8, height * 0.8),
                painter: ColorWheelPainter(
                  indicatorAngle: angle,
                  lightness: lightness,
                  saturation: saturation,
                ),
              ),
            ),
          ),
        if (firstPage)
          Expanded(
            flex: 1,
            child: Text("Lightness"),
          ),
        if (firstPage)
          Expanded(
            flex: 2,
            child: Slider(
              value: lightness,
              min: 0.0,
              max: 1.0,
              onChanged: (newValue) {
                setState(() {
                  lightness = newValue;
                });
              },
            ),
          ),
        if (firstPage)
          Expanded(
            flex: 1,
            child: Text("Saturation"),
          ),
        if (firstPage)
          Expanded(
            flex: 2,
            child: Slider(
              value: saturation,
              min: 0.0,
              max: 1.0,
              onChanged: (newValue) {
                setState(() {
                  saturation = newValue;
                });
              },
            ),
          ),
        if (!firstPage)
          Expanded(
            flex: 10,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: Colors.primaries.length,
              itemBuilder: (context, index) {
                Color color = Colors.primaries[index];
                return GestureDetector(
                  onLongPress: (){
                    showColorShades(context, color);
                  },
                  onTap: (){
                    colorCubit.changeColor(color);
                    setState(() {
                      currentColor = color;
                    });
                  },
                  child: Container(
                    color: color,
                    child: currentColor == color ?
                      Center(
                        child: Icon(
                          Icons.thumb_up_alt_outlined
                        )
                      )
                    : Container()
                  )
                );
              },
            ),
          ),
        
      ],
    );
  }

  void showColorShades(BuildContext context, Color color) {
    List<Color> shades = List.generate(10, (index) => color.withOpacity((index + 1) * 0.1));
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: shades.map((shade) {
            return GestureDetector(
              onTap: (){
                colorCubit.changeColor(shade);
                setState(() {
                  currentColor = color;
                });
                Navigator.pop(context);
              },
              child: Container(
                height: 50,
                color: shade,
              )
            );
          }).toList(),
        );
      }
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
  final double lightness;
  final double saturation;
  final double increment;
  final double indicatorAngle;

  ColorWheelPainter({
    required this.lightness,
    required this.saturation, 
    this.increment = 0.5, 
    required this.indicatorAngle
  });

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
    /*final indicatorRadius = 10.0; // Radius of the small circle
    final indicatorX = center.dx + (radius - indicatorRadius) * cos(indicatorAngle * pi / 180);
    final indicatorY = center.dy + (radius - indicatorRadius) * sin(indicatorAngle * pi / 180);

    final indicatorPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(indicatorX, indicatorY), indicatorRadius, indicatorPaint);
    */
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}