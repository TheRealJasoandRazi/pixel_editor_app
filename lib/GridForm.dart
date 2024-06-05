import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_editor_app/CreateGrid.dart';
import 'package:flutter/services.dart';

import 'Cubit/FormState.dart';
import 'Cubit/GridListState.dart';

class GridForm extends StatefulWidget {

  @override
  State<GridForm> createState() => _GridFormState();
}

class _GridFormState extends State<GridForm> {
  Offset formPosition = Offset(0,0);

  void _handleFormUpdate(DragUpdateDetails details) {
    setState(() {
      formPosition += details.delta;
    });
  }

  @override
  Widget build(BuildContext context) {
    final formCubit = BlocProvider.of<FormCubit>(context); //retieve form state
    final gridListCubit = BlocProvider.of<GridListCubit>(context);

    //grabs values entered into the form
    final TextEditingController _widthController = TextEditingController();
    final TextEditingController _heightController = TextEditingController();
    
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if(formPosition == Offset(0,0)){//initialise form location
      formPosition = Offset(screenWidth * 0.25, screenWidth * 0.25);
    }

    final height = screenHeight * 0.25;

    return Positioned(
      left: formPosition.dx,
      top: formPosition.dy,
      child: GestureDetector(
        onPanUpdate: _handleFormUpdate,
        child: Container(
          width: height,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.grey.shade400,
          ),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    'Grid Form',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SizedBox(
                    width: height * 0.8,
                    child: TextField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      controller: _widthController,
                      decoration: InputDecoration(
                        labelText: 'Width',
                        fillColor: Colors.grey.shade400,
                        filled: true,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SizedBox(
                    width: height * 0.8,
                    child: TextField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      controller: _heightController,
                      decoration: InputDecoration(
                        labelText: 'Height',
                        fillColor: Colors.grey.shade400,
                        filled: true,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    width: 100, // Adjust the width as needed
                    height: 50, // Adjust the height as needed
                    decoration: BoxDecoration(
                        color: Colors.grey.shade500, // Background color
                        borderRadius: BorderRadius.circular(8.0), // Rounded corners
                        boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // Shadow position
                            ),
                        ],
                    ),
                    child: GestureDetector(
                      onTap: () {
                      final String widthInput = _widthController.text;
                      final String heightInput = _heightController.text;

                      int? width = int.tryParse(widthInput);
                      int? height = int.tryParse(heightInput);

                      // Check if the conversions were successful
                      if (width != null && height != null) {
                        if(width <= 200 && height <= 200){
                          gridListCubit.addGrid(CreateGrid(width: width, height: height));
                        }
                      } else {
                        print("aint work");
                      }
                      formCubit.changeFormVisibility();
                      },
                      child: Center(
                          // Center the text within the container
                          child: Text(
                              'Submit',
                              style: TextStyle(color: Colors.white),
                          ),
                      ),
                    )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  
  }
}