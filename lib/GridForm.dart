import 'package:flutter/material.dart';

class GridForm extends StatefulWidget {
  final Function() changeVisibility;

  GridForm({ //pass in the homepage method to change visibility of form
    required this.changeVisibility,
  });

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
    //grabs values entered into the form
    final TextEditingController _widthController = TextEditingController();
    final TextEditingController _heightController = TextEditingController();
    
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if(formPosition == Offset(0,0)){//initialise form location
      formPosition = Offset(screenWidth/2, screenWidth/2);
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

                      // Print the input values for testing purposes
                      print('Width: $widthInput');
                      print('Height: $heightInput');

                      widget.changeVisibility();
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