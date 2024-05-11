import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pixel_editor_app/ColorWheelTool.dart';
import 'package:pixel_editor_app/CreateGrid.dart';
import 'package:pixel_editor_app/GridTool.dart';
import 'package:pixel_editor_app/PaintTool.dart';

import 'CustomToolBar.dart'; //Custome Tool Bar
import 'GridForm.dart';
import 'Cubit/Form_State.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FormCubit(), //gives access to form state to all descendants
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'Flutter Demo Home Page'),
      )
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

  void reload(){
    setState(() {
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
  late ColorWheelTool colorWheelTool = ColorWheelTool(reload: reload); //instantiated

  @override
  void initState() { //only runs once
    super.initState(); //instantiate buttons
    gridForm = GridForm(onFormSubmission: _handleGridFormSubmission);
    gridTool = GridTool();
    paintTool = PaintTool(colorWheel: colorWheelTool.colorWheelPopUp);
  }
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    customToolBar = CustomToolBar(
      screenHeight: screenHeight,
      screenWidth: screenWidth,
      ypos: screenHeight / 4,
    ); 

    //add buttons to custom toolbar
    customToolBar.add(gridTool);
    customToolBar.add(paintTool);
    customToolBar.add(colorWheelTool);
    
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
          if(colorWheelTool.colorWheelVisibility)
            colorWheelTool.colorWheelPopUp, //color wheel pop up
          //add movable form
          BlocBuilder<FormCubit, bool>(
            builder: (context, state) {
              if (state == true) {
                return gridForm;
              } else {
                return Container();
              }
            }
          )
        ],
      ),
    );
  }
}

