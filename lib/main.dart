import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_editor_app/Cubit/DropperState.dart';
import 'package:pixel_editor_app/Cubit/ExportSelectionState.dart';
import 'package:pixel_editor_app/Cubit/SelectedGridState.dart';
import 'package:pixel_editor_app/Pages/DeleteGridPage.dart';

import 'package:pixel_editor_app/Pages/EditorPage.dart';
import 'package:pixel_editor_app/Pages/Export/ExportPage.dart';
import 'package:pixel_editor_app/Pages/ImportPage.dart';


//state imports
import 'Cubit/ColorState.dart';
import 'Cubit/PaintState.dart';
import 'Cubit/GridListState.dart';
import 'Cubit/EraseState.dart';
import 'Cubit/ColorWheelState.dart';

//pages
import 'Pages/CreateGridPage.dart';
import 'Pages/Export/ExportGifPage.dart';
import 'Pages/Export/ExportImagePage.dart';

void main() {
  WidgetsApp.debugAllowBannerOverride = false; // Remove debug banner if needed
  //debugPaintLayerBordersEnabled = true; // Enable layer borders
  debugProfilePaintsEnabled = true; //for profile mode
  debugRepaintRainbowEnabled = true;
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
          create: (context) => ColorCubit(),
        ),
        BlocProvider(
          create: (context) => PaintCubit(),
        ),
        BlocProvider(
          create: (context) => GridListCubit(),
        ),
        BlocProvider(
          create: (context) => EraseCubit(),
        ),
        BlocProvider(
          create: (context) => ExportSelectionCubit(),
        ),
        BlocProvider(
          create: (context) => ColorWheelCubit(),
        ),
        BlocProvider(
          create: (context) => SelectedGridCubit(),
        ),
        BlocProvider(
          create: (context) => DropperCubit(),
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
          '/DeleteGridPage': (context) => DeleteGridPage(),
          '/ExportPage': (context) => ExportPage(),
          '/ExportImagePage': (context) => ExportImagePage(),
          '/ExportGifPage': (context) => ExportGifPage(),
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
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

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
    );
  }
}

