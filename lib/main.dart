import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_editor_app/Cubit/ExportSelectionState.dart';
import 'package:pixel_editor_app/ExportForm.dart';
import 'package:pixel_editor_app/ImageWrapper.dart';
import 'package:pixel_editor_app/Pages/EditorPage.dart';
import 'package:pixel_editor_app/Pages/ImportPage.dart';
import 'package:pixel_editor_app/Tools/BinTool.dart';
import 'package:pixel_editor_app/ColorWheelPopUp.dart';

import 'package:pixel_editor_app/Tools/ColorWheelTool.dart';
import 'package:pixel_editor_app/CreateGrid.dart';
import 'package:pixel_editor_app/Tools/ExportTool.dart';
import 'package:pixel_editor_app/Tools/GridTool.dart';
import 'package:pixel_editor_app/Tools/PaintTool.dart';
import 'package:pixel_editor_app/Tools/EraseTool.dart';
import 'package:pixel_editor_app/Tools/PixelateTool.dart';
import 'Tools/ImportTool.dart';

import 'CustomToolBar.dart'; //Custome Tool Bar
import 'GridForm.dart';
import 'PixelateForm.dart';
import 'Tools/SwitchTool.dart';

//state imports
import 'Cubit/FormState.dart';
import 'Cubit/ColorState.dart';
import 'Cubit/PaintState.dart';
import 'Cubit/ColorWheelState.dart';
import 'Cubit/GridListState.dart';

import 'Cubit/EraseState.dart';
import 'Cubit/ExportState.dart';
import 'Cubit/ImageListState.dart';
import 'Cubit/PixelateState.dart';
import 'Cubit/SwitchState.dart';
import 'Cubit/ProgressState.dart';

import 'ColorWheel.dart';

//pages
import 'Pages/CreateGridPage.dart';

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
          create: (context) => EraseCubit(),
        ),
        BlocProvider(
          create: (context) => ExportCubit(),
        ),
        BlocProvider(
          create: (context) => ExportSelectionCubit(),
        ),
        BlocProvider(
          create: (context) => ImageListCubit(),
        ),
        BlocProvider(
          create: (context) => PixelateCubit(),
        ),
        BlocProvider(
          create: (context) => SwitchCubit(),
        ),
        BlocProvider(
          create: (context) => SwitchCubit(),
        ),
        BlocProvider(
          create: (context) => ProgressCubit(),
        ),
        BlocProvider(
          create: (context) => GridList(),
        ),
      ], //gives access to form state to all descendants
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.deepPurple,
          scaffoldBackgroundColor: Colors.black,
          textTheme: TextTheme(
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const MyHomePage(title: 'Flutter Demo Home Page'),
          '/CreateGridPage': (context) => CreateGridPage(),
          '/EditorPage': (context) => EditorPage(),
          '/ImportPage': (context) => ImportPage(previousPage: "/MainPage",),
        },
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
  /*
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
  late ExportForm exportForm;
  late ImportTool importTool;
  late PixelateTool pixelateTool;
  late PixelateForm pixelateForm;
  late SwitchTool switchTool;

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
    exportForm = ExportForm();
    importTool = ImportTool();
    pixelateTool = PixelateTool();
    pixelateForm = PixelateForm();
    switchTool = SwitchTool();
  }
  ColorWheel colorWheel = ColorWheel();
  */
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
/*
    customToolBar = CustomToolBar(
      screenHeight: screenHeight,
      screenWidth: screenWidth,
      ypos: screenHeight / 4,
    ); 

    //add buttons to custom toolbar
    customToolBar.add(switchTool);
    customToolBar.add(gridTool);
    customToolBar.add(paintTool);
    customToolBar.add(colorWheelTool);
    customToolBar.add(eraseTool);
    customToolBar.add(binTool);
    customToolBar.add(importTool);
    customToolBar.add(exportTool);
    customToolBar.add(pixelateTool);*/
    
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: screenWidth * 0.25,
          height: screenHeight * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Let's get started!", style: Theme.of(context).textTheme.bodyText1),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/CreateGridPage');
                },
                child: Text("Create Grid"),
              ),
              Text("OR"),
              Text("Start by using an image"),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/ImportPage');
                },
                child: Text("Import"),
              ),
            ],
          ),
        )
      )
      /*body: Stack(
        children: [
          Center(
            child: colorWheel
          ),
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
          //add movable grid form
          BlocBuilder<FormCubit, bool>(
            builder: (context, state) {
              if (state) {
                return gridForm;
              } else {
                return Container();
              }
            }
          ),
          BlocBuilder<ExportCubit, bool>(
            builder: (context, state) {
              if(state){
                return exportForm;
              } else {
                return Container();
              }
            },
          ),
          BlocBuilder<ImageListCubit, List<ImageWrapper>>(
            builder: (context, state) {
              return Stack(
                children: state,
              );
            },
          ),
          BlocBuilder<PixelateCubit, bool>(
            builder: (context, state) {
              if(state){
                return pixelateForm;
              } else {
                return Container();
              }
            },
          ),
          BlocBuilder<ProgressCubit, ProgressState>(
            builder: (context, state) {
              if(state.visible){
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text(
                      state.text,
                      style: TextStyle(fontSize: 20),
                    ),
                    LinearProgressIndicator(
                      value: state.progress, //has to be between 0 and 1
                      semanticsLabel: 'Linear progress indicator',
                    )
                  ],
                );
              } else {
                return Container();
              }
            }
          )
        ],
      ),*/
    );
  }
}

