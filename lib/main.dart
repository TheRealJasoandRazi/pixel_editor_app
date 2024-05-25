import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_editor_app/Tools/BinTool.dart';
import 'package:pixel_editor_app/ColorWheelPopUp.dart';

import 'package:pixel_editor_app/Tools/ColorWheelTool.dart';
import 'package:pixel_editor_app/CreateGrid.dart';
import 'package:pixel_editor_app/Tools/ExportTool.dart';
import 'package:pixel_editor_app/Tools/GridTool.dart';
import 'package:pixel_editor_app/Tools/PaintTool.dart';
import 'package:pixel_editor_app/Tools/EraseTool.dart';

import 'CustomToolBar.dart'; //Custome Tool Bar
import 'GridForm.dart';

//state imports
import 'Cubit/FormState.dart';
import 'Cubit/ColorState.dart';
import 'Cubit/PaintState.dart';
import 'Cubit/ColorWheelState.dart';
import 'Cubit/GridListState.dart';
import 'Cubit/RotatedToolBarState.dart';
import 'Cubit/EraseState.dart';
import 'Cubit/ExportState.dart';

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
        BlocProvider(
          create: (context) => EraseCubit(),
        ),
        BlocProvider(
          create: (context) => ExportCubit(),
        )
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
  
  //declare an instance of all classes
  late CustomToolBar customToolBar;
  late GridTool gridTool;
  late PaintTool paintTool; 
  late GridForm gridForm;
  late ColorWheelTool colorWheelTool;
  late ColorWheelPopUp colorWheelPopUp;
  late BinTool binTool;
  late EraseTool eraseTool;
  late ExportTool exportTool;

  @override
  void initState() { //only runs once
    super.initState(); //instantiate buttons
    gridForm = GridForm();
    gridTool = GridTool();
    paintTool = PaintTool();
    colorWheelTool = ColorWheelTool();
    colorWheelPopUp = ColorWheelPopUp();
    binTool = BinTool();
    eraseTool = EraseTool();
    exportTool = ExportTool();
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
    customToolBar.add(eraseTool);
    customToolBar.add(binTool);
    customToolBar.add(exportTool);
    
    return Scaffold(
      body: Stack(
        children: [
          customToolBar,
          BlocBuilder<GridListCubit, List<CreateGrid>>(
            builder: (context, state) {
              return Stack(
                children: state,
              );
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

