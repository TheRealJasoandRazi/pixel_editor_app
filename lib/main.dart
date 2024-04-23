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

  void _calculateToolbarPosition() {
    RenderBox? box = toolBarKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      Offset position = box.localToGlobal(Offset.zero);
      setState(() {
        toolbarPosition = position;
        if (originalToolbarPosition == null) {
            originalToolbarPosition = position;
        }
      });
    }
  } 

  int _currentColumnIndex = 1; //by default is in column 1
  void _moveContainer(index){
    setState(() {
      _currentColumnIndex = index;
    });
  }

  Widget toolBar(Alignment alignment) {
    BorderRadius borderRadius;
    double? widthf;
    double? heightf;

    if (alignment == Alignment.centerLeft) {
      borderRadius = BorderRadius.only(
        topRight: Radius.circular(16.0),
        bottomRight: Radius.circular(16.0),
      );
      widthf = 0.5;
      heightf = 0.5;
    } else if (alignment == Alignment.centerRight) {
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(16.0),
        bottomLeft: Radius.circular(16.0),
      );
      widthf = 0.5;
      heightf = 0.5;
    } else if (alignment == Alignment.topCenter) {
      borderRadius = BorderRadius.only(
        bottomLeft: Radius.circular(16.0),
        bottomRight: Radius.circular(16.0),
      );
      widthf = 1.0;
      heightf = 0.1;
    } else if (alignment == Alignment.bottomCenter) {
      borderRadius = BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      );
      widthf = 1.0;
      heightf = 0.1;
    } else {
      // Default case if no matching alignment is found
      borderRadius = BorderRadius.circular(0.0);
    }

    Widget toolbarWidget = GestureDetector(
        key: toolBarKey,
        onPanUpdate: (details) {
            setState(() {
                toolbarPosition += details.delta;
                print("Original position: $originalToolbarPosition");
                print("Current position: $toolbarPosition");
            });
        },
        child: Container(
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: borderRadius,
            ),
        ),
    );

    print(toolbarPosition);
    print(originalToolbarPosition);
    if (toolbarPosition != originalToolbarPosition) {
      print("moved");
      return Positioned(
          left: toolbarPosition.dx,
          top: toolbarPosition.dy,
          child: toolbarWidget,
      );
    }
    print("not");
    return Expanded(
        child: Align(
            alignment: alignment,
            child: FractionallySizedBox(
                widthFactor: widthf,
                heightFactor: heightf,
                child: toolbarWidget,
            ),
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _calculateToolbarPosition();
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        child: Row(
          children: [
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Column(
                children: [
                  if(_currentColumnIndex == 1)
                    toolBar(Alignment.centerLeft),
                ],
              )
            ),
            Flexible(
              flex: 6,
              fit: FlexFit.tight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(_currentColumnIndex == 2)
                    toolBar(Alignment.topCenter),
                  if(_currentColumnIndex == 4)
                    toolBar(Alignment.bottomCenter),
                ],
              )
            ),
            Flexible(
              flex: 2,
              fit: FlexFit.tight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (_currentColumnIndex == 3)
                    toolBar(Alignment.centerRight),
                ],
              )
            ),
          ],
        )
      )
    );
  }
}
