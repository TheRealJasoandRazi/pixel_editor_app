import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart'; //leave for later
import 'package:pixel_editor_app/GridTool.dart';
import 'package:pixel_editor_app/PaintTool.dart';

import 'CustomToolBar.dart'; //Custome Tool Bar

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});//the required defines it parameters

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Offset formPosition = Offset.zero;

  void _handleFormUpdate(DragUpdateDetails details) {
    setState(() {
      formPosition += details.delta;
    });
  }

  void _rebuildHomePage() {
    setState(() {
      print("rebuild");
    });
  }

  Widget gridForm(height){
    //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _width = TextEditingController();
    final TextEditingController _height = TextEditingController();

    return Container(
      width: height, //both use same value == box shape
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.blueAccent,
      ),
      child: Form(
        //key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "Grid Form",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                width: height * 0.8, // Adjust the width as needed
                child: TextField(
                  controller: _width,
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
                width: height * 0.8, // Adjust the width as needed
                child: TextField(
                  controller: _height,
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
                    String _widthInput = _width.text;
                    String _heightInput = _height.text;

                    print(_widthInput); //for testing
                    print(_heightInput);
                  },
                  child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  late CustomToolBar customToolBar; // Declare as a state variable
  late GridTool gridTool; // Declare as a state variable
  late PaintTool paintTool; // Declare as a state variable

  @override
  void initState() {
    super.initState();
    gridTool = GridTool(rebuildHomePage: _rebuildHomePage);
    paintTool = PaintTool();
  }
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if(formPosition == Offset(0,0)){//initialise form location
      formPosition = Offset(screenWidth/2, screenWidth/2);
    }
    customToolBar = CustomToolBar(
      screenHeight: screenHeight,
      screenWidth: screenWidth,
      ypos: screenHeight / 4,
    );
    customToolBar.add(gridTool);
    customToolBar.add(paintTool);

    return Scaffold(
      body: Stack(
        children: [
          // Pixel editor canvas
          Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
          ),
          // Movable toolbar
          customToolBar,
          //movable form
          if (gridTool.isFormVisibile)
            Positioned(
              left: formPosition.dx,
              top: formPosition.dy,
              child: GestureDetector(
                onPanUpdate: _handleFormUpdate,
                child: gridForm(screenHeight * 0.25),
              )
            ),
        ],
      ),
    );
  }
}

