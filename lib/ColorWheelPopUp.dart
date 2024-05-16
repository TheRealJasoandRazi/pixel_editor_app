import 'package:flutter/material.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Cubit/ColorState.dart';

class ColorWheelPopUp extends StatefulWidget {

  @override
  State<ColorWheelPopUp> createState() => _ColorWheelPopUpState();
}

class _ColorWheelPopUpState extends State<ColorWheelPopUp> {
  Offset colorWheelPosition = Offset(0,0);

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
        child: SizedBox(
          width: screenWidth * 0.35,
          height: screenHeight * 0.35,
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Card( //might change to container
              elevation: 1,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final colorPickerWidth = constraints.maxWidth * 0.1; //portion of card/sizedbox width
                  final colorPickerHeight = constraints.maxHeight * 0.1; //portion of card/sizedbox height
                  return ColorPicker(
                    onColorChanged: (Color color) {
                      setState(() {
                        colorCubit.changeColor(color);
                      });
                    },
                    width: colorPickerWidth,
                    height: colorPickerHeight,
                    borderRadius: colorPickerWidth / 2,
                    heading: Text(
                      'Select color',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    subheading: Text(
                      'Select color shade',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
