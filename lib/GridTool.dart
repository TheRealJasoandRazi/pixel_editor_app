import 'package:flutter/material.dart';
import 'toolBarButtons.dart';

class GridTool extends StatefulWidget with ToolBarButtons {
  final Function() rebuildHomePage;
  bool _isFormVisible = false;
  Offset _formPosition = Offset.zero;

  GridTool({
    required this.rebuildHomePage
  });

  bool get isFormVisibile => _isFormVisible;
  Offset get formPosition => _formPosition;

  //final _GridToolState state = _GridToolState();

  /*Widget getGridForm(double height) {
    return state.gridForm(height);
  }*/

  @override
  _GridToolState createState() => _GridToolState();
}

class _GridToolState extends State<GridTool> {
  void _toggleFormVisibility() {
    setState(() {
      widget._isFormVisible = !widget._isFormVisible;
    });
    widget.rebuildHomePage();
    print(widget._isFormVisible);
  }

  void _handleFormUpdate(DragUpdateDetails details) {
    setState(() {
      widget._formPosition += details.delta;
    });
  }

  Widget gridForm(double height) {
    final TextEditingController _widthController = TextEditingController();
    final TextEditingController _heightController = TextEditingController();

    return Container(
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
                  _toggleFormVisibility();
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.toolBarButton(
      Icons.grid_on,
      _toggleFormVisibility,
      Colors.grey.shade300,
    );
  }
}
