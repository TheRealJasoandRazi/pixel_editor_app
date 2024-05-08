import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:pixel_editor_app/ColorWheelTool.dart';
import 'package:pixel_editor_app/CreateGrid.dart';
import 'package:pixel_editor_app/GridTool.dart';
import 'package:pixel_editor_app/PaintTool.dart';

import 'CustomToolBar.dart'; //Custome Tool Bar
import 'GridForm.dart';
import 'ColorWheelPopUp.dart';

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
  List<CreateGrid> gridList = []; //list of grids

  bool formVisibility = false; //grid form variable and method
  void changeVisibility(){
    setState(() {
      formVisibility = !formVisibility;
    });
  }

  bool colorWheelVisibility = false; //handles visibility for color wheel
  void changeColorWheelVisibility(){
    setState(() {
      colorWheelVisibility = !colorWheelVisibility;
    });
  }

  void _handleGridFormSubmission(int width, int height) {
    setState(() {
        CreateGrid grid = CreateGrid(width: width, height: height, paintTool: paintTool);
        gridList.add(grid);
    });
  }

  //declare an instance of all classes
  late CustomToolBar customToolBar;
  late GridTool gridTool;
  late PaintTool paintTool; 
  late GridForm gridForm;
  late ColorWheelTool colorWheelTool;
  late ColorWheelPopUp colorWheelPopUp = ColorWheelPopUp();

  @override
  void initState() {
    super.initState(); //instantiate buttons
    gridForm = GridForm(changeVisibility: changeVisibility, onFormSubmission: _handleGridFormSubmission);
    gridTool = GridTool(changeVisibility: changeVisibility);
    paintTool = PaintTool();
    colorWheelTool = ColorWheelTool(changeColorWheelVisibility: changeColorWheelVisibility);
  }
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    //instantiate toolbar     
    customToolBar = CustomToolBar(
      screenHeight: screenHeight,
      screenWidth: screenWidth,
      ypos: screenHeight / 4,
    ); 

    //add buttons to custom toolbar
    customToolBar.add(gridTool);
    customToolBar.add(paintTool);
    customToolBar.add(colorWheelTool);

    //CreateGrid grid = CreateGrid(width: 20, height: 20, paintTool: paintTool);
    
    return Scaffold(
      body: Stack(
        children: [
          // Pixel editor canvas
          Container(
            color: Colors.white,
            width: double.infinity,
            height: double.infinity,
          ),
          // display movable toolbar
          customToolBar,
          for (var widget in gridList) widget, //renders all grids
          if(colorWheelVisibility)
            colorWheelPopUp, //color wheel pop up
          //add movable form
          if (formVisibility)
            gridForm
        ],
      ),
    );
  }
}

