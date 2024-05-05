import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart'; //leave for later
import 'package:pixel_editor_app/GridTool.dart';
import 'package:pixel_editor_app/PaintTool.dart';

import 'CustomToolBar.dart'; //Custome Tool Bar
import 'GridForm.dart';

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
  bool formVisibility = false; //grid form variable and method
  void changeVisibility(){
    setState(() {
      formVisibility = !formVisibility;
    });
  }

  //declare an instance of all classes
  late CustomToolBar customToolBar;
  late GridTool gridTool;
  late PaintTool paintTool; 
  late GridForm gridForm;

  @override
  void initState() {
    super.initState(); //instantiate buttons
    gridForm = GridForm(changeVisibility: changeVisibility);
    gridTool = GridTool(changeVisibility: changeVisibility);
    paintTool = PaintTool();
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
          //add movable form
          if (formVisibility)
            gridForm
        ],
      ),
    );
  }
}

