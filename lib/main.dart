import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  GlobalKey toolBarKey = GlobalKey();
  Offset? originalToolbarPosition;
  Offset toolbarPosition = Offset.zero;

  void _handlePanUpdate(DragUpdateDetails details) {
    setState(() {
      toolbarPosition += details.delta;
    });
  }

  Widget toolBar(double width, double height){
    final screenHeight = MediaQuery.of(context).size.height;
    double threshold = screenHeight * 0.05;
    double lowerThreshold = screenHeight - threshold - height;
    bool rotatedBar = false;

    if(toolbarPosition.dy <= threshold || toolbarPosition.dy >= lowerThreshold)
    {
      rotatedBar = true;
    } else {
      rotatedBar = false;
    }

    return AnimatedRotation(
      turns: rotatedBar ? 0.25 : 0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child:Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: Colors.blue,
        ),
      ), 
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if(toolbarPosition == Offset(0,0)){//initialise toolbar location
      toolbarPosition = Offset(0, screenHeight/4);
    }

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
          Positioned(
            left: toolbarPosition.dx,
            top: toolbarPosition.dy,
            child: GestureDetector(
              onPanUpdate: _handlePanUpdate,
              child: toolBar(screenWidth * 0.1, screenHeight * 0.5)
            ),
          ),
        ],
      ),
    );
  }
}
