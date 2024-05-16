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
    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      left: colorWheelPosition.dx,
      top: colorWheelPosition.dy,
      child: GestureDetector(
        onPanUpdate: _handleColorWheelUpdate,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(12.0),
          ),
          width: screenWidth * 0.25,
          child: ColorPicker(
            onColorChanged: (Color color) {
              setState(() {
                colorCubit.changeColor(color);
              });
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
    );
  }
}
