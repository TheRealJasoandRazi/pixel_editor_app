import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Cubit/ColorState.dart';

class ColorWheelPopUp extends StatefulWidget {

  @override
  State<ColorWheelPopUp> createState() => _ColorWheelPopUpState();
}

class _ColorWheelPopUpState extends State<ColorWheelPopUp> {
  late Offset colorWheelPosition = Offset(0,0);
  double size = 0;

  void _handleColorWheelUpdate(DragUpdateDetails details) {
    setState(() {
      colorWheelPosition += details.delta;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorCubit = BlocProvider.of<ColorCubit>(context); //retieve form state

    final screenWidth = MediaQuery.of(context).size.width;
    //final screenHeight = MediaQuery.of(context).size.height;

    if(size == 0){
      size = screenWidth * 0.25;
    }

    return Stack(children: [
        Positioned(
          left: colorWheelPosition.dx + size,
          top: colorWheelPosition.dy - 10,
          child: GestureDetector( //adjusts size of colour wheel
            onPanUpdate: (details) {
              setState(() { 
                size += details.delta.dx; 
                size = size.clamp(screenWidth * 0.15, screenWidth * 0.50); //add constraints to size
              }); 
            },
            child: Icon(
              Icons.arrow_outward
            ),
          )
        ),
        Positioned(
          left: colorWheelPosition.dx,
          top: colorWheelPosition.dy,
          child: GestureDetector(
            onPanUpdate: _handleColorWheelUpdate,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12.0),
              ),
              width: size,
              child: ColorPicker(
                onColorChanged: (Color color) {
                  colorCubit.changeColor(color);
                },
                width: 20, //in dp
                height: 20,
                borderRadius: 12,
                heading: Text(
                  'Select color',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                subheading: Text(
                  'Select color shade',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              )
            )
          )
        )
      ]
    );
  }
}
