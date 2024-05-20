import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_editor_app/BinTool.dart';
import 'package:pixel_editor_app/ColorWheelPopUp.dart';

import 'package:pixel_editor_app/ColorWheelTool.dart';
import 'package:pixel_editor_app/CreateGrid.dart';
import 'package:pixel_editor_app/GridTool.dart';
import 'package:pixel_editor_app/PaintTool.dart';

import 'CustomToolBar.dart'; //Custome Tool Bar
import 'GridForm.dart';

//state imports
import 'Cubit/FormState.dart';
import 'Cubit/ColorState.dart';
import 'Cubit/PaintState.dart';
import 'Cubit/ColorWheelState.dart';
import 'Cubit/GridListState.dart';
import 'Cubit/RotatedToolBarState.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FormCubit(),
        ),
        BlocProvider(
          create: (context) => ColorCubit(),
        ),
        BlocProvider(
          create: (context) => PaintCubit(),
        ),
        BlocProvider(
          create: (context) => ColorWheelCubit(),
        ),
        BlocProvider(
          create: (context) => GridListCubit(),
        ),
        BlocProvider(
          create: (context) => RotatedToolBarCubit(),
        ),
      ], //gives access to form state to all descendants
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

  void _handleGridFormSubmission(int width, int height) {
    setState(() {
        gridList.add(CreateGrid(width: width, height: height));
    });
  }

  //declare an instance of all classes
  late CustomToolBar customToolBar;
  late GridTool gridTool;
  late PaintTool paintTool; 
  late GridForm gridForm;
  late ColorWheelTool colorWheelTool;
  late ColorWheelPopUp colorWheelPopUp;
  late BinTool binTool;

  @override
  void initState() { //only runs once
    super.initState(); //instantiate buttons
    gridForm = GridForm();
    gridTool = GridTool();
    paintTool = PaintTool();
    colorWheelTool = ColorWheelTool();
    colorWheelPopUp = ColorWheelPopUp();
    binTool = BinTool();
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
    customToolBar.add(binTool);
    
    return Scaffold(
      body: Stack(
        children: [
          customToolBar,
          BlocBuilder<GridListCubit, List<CreateGrid>>( //still buggy as shit
            builder: (context, state) {
              if (state.isNotEmpty) {
                print("Building stack with ${state.length} items");
                return Stack(
                  children: state.asMap().entries.map((entry) {
                    int index = entry.key;
                    CreateGrid widget = entry.value;
                    print("Index: $index, Widget: $widget");
                    if (index < state.length) {
                      return widget;
                    } else {
                      print("Index out of range: $index for state length ${state.length}");
                      return Container();
                    }
                  }).toList(),
                );
              }
              return Container(); 
            },
          ),
          //for (var widget in gridList) widget, //renders all grids
          BlocBuilder<ColorWheelCubit, bool>(
            builder: (contex, state) {
              if(state == true) {
                return colorWheelPopUp; //color wheel pop up
              } else {
                return Container();
              }
            }
          ),
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

