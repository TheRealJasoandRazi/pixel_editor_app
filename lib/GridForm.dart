import 'package:flutter/material.dart';

class GridForm extends StatefulWidget {
  final Function() changeVisibility;

  GridForm({
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
            color: Colors.blueAccent,
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
                        fillColor: Colors.blueAccent,
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
                        fillColor: Colors.blueAccent,
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
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle form submission
                      final String widthInput = _widthController.text;
                      final String heightInput = _heightController.text;

                      // Print the input values for testing purposes
                      print('Width: $widthInput');
                      print('Height: $heightInput');

                      // Toggle form visibility
                      widget.changeVisibility();
                    },
                    child: Text('Submit'),
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