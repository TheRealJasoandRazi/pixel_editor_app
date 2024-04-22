import 'package:flutter/material.dart';

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
  int _currentColumnIndex = 1; //by default is in column 1
  void _moveContainer(index){
    setState(() {
      _currentColumnIndex = index;
    });
  }

  Widget toolBar(Alignment alignment) {
    BorderRadius borderRadius;
    double widthf = 0;
    double heightf = 0;

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

    return Expanded(
      child: Align(
        alignment: alignment, // Align the child to the middle left
        child: FractionallySizedBox(
          widthFactor: widthf, // 50% of the width of the parent
          heightFactor: heightf, // 50% of the height of the parent
          child: GestureDetector(
            onVerticalDragUpdate: (details) {
              if (details.delta.dy < 0) {
                // Upward movement
                _moveContainer(2);
                print('up');
              } else if (details.delta.dy > 0) {
                // Downward movement
                _moveContainer(4);
                print('down');
              }
            },
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx > 0) {
                // Rightward movement
                _moveContainer(3);
                print('right');
              } else if (details.delta.dx < 0) {
                // Leftward movement
                _moveContainer(1); // Add handling for leftward movement
                print('left');
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey, // Background color set to blue
                borderRadius: borderRadius,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
