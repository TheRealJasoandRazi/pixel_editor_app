import 'package:flutter/material.dart';
import '../Cubit/ColorWheelState.dart';
import 'package:pixel_editor_app/Cubit/RecentColorsState.dart';
import 'dart:math';
import '../Cubit/ColorState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FullScreenColorWheelPage extends StatefulWidget { 
  const FullScreenColorWheelPage({super.key});

  @override
  State<FullScreenColorWheelPage> createState() => _FullScreenColorWheelState();
}

class _FullScreenColorWheelState extends State<FullScreenColorWheelPage> {

  late Color selectedColor;
  double angle = 0.0;
  Offset? indicatorPosition;
  double saturation = 1.0;
  double lightness = 0.5;

  late final ColorCubit colorCubit;
  late final ColorWheelCubit colorWheelCubit;
  late RecentColorsCubit recentColorsCubit;

  @override
   void initState() {
    super.initState();
    colorCubit = context.read<ColorCubit>();
    colorWheelCubit = context.read<ColorWheelCubit>();
    recentColorsCubit = context.read<RecentColorsCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded( //color wheel
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
                    indicatorPosition = offset;
                  });
                },
                onPanEnd: (details) { //add color to recents when user lets go
                  recentColorsCubit.addColor(colorCubit.state); 
                },
                child: CustomPaint(
                  size: Size(screenWidth, screenHeight), //max size
                  painter: ColorWheelPainter(
                    indicatorPosition: indicatorPosition,
                    lightness: lightness,
                    saturation: saturation,
                  ),
                ),
              )
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                    child: Text("Lightness"),
                  ),
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
                ]
              )
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                    child: Text("Saturation"),
                  ),
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
                ],
              )
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                    flex: 1,
                    child: Text("Recent Colors"),
                  ),
                  Expanded(
                    flex: 3,
                    child: recentColorsList()
                  )
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: FractionallySizedBox(
                widthFactor: 0.5,
                child: BlocBuilder<ColorCubit, Color>(
                  builder: (context, state) {
                    return Container(
                      color: colorCubit.state,
                    );
                  }
                )
              )
            ),
            Expanded(
              flex: 1,
              child: ElevatedButton(
                onPressed: (){
                  Navigator.pop(context);
                },
                child: Text(
                  "Back"
                ),
              )
            )
          ]
        )
      )
    );
  }

  Widget recentColorsList(){
    return BlocBuilder<RecentColorsCubit, List<Color>>(
      builder: (context, state) {
        return LayoutBuilder(
          builder: (context, constraints) {
            double itemWidth = constraints.maxWidth / 4 ;
            List<Widget> row = [];
            for (var color in state){
              row.add(
                Padding( //Recent Color Wrapper
                  padding: EdgeInsets.all(4.0),
                  child: GestureDetector(
                    onTap: (){
                      setState((){
                        colorCubit.changeColor(color);
                      });
                    },
                    child: Container( 
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: color,
                      ),
                      width: itemWidth,
                      child: Center(
                        child: color == colorCubit.state ? Icon(
                          Icons.thumb_up_alt_outlined,
                        ) : null
                      )
                    )
                  )
                )
              );
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center the items horizontally
              children: row,
            );
          },
        );
      }
    );
  }
}

class ColorWheelPainter extends CustomPainter {
  final double lightness;
  final double saturation;
  final double increment;
  final Offset? indicatorPosition;

  ColorWheelPainter({
    required this.lightness,
    required this.saturation, 
    this.increment = 0.5, 
    required this.indicatorPosition
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

    /*if (indicatorPosition != null) {
      final indicatorPaint = Paint()
        ..color = Colors.black
        ..style = PaintingStyle.fill;

      canvas.drawCircle(indicatorPosition!, 10, indicatorPaint);
    }*/
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}