import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_box_transform/flutter_box_transform.dart';

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
  Offset toolbarPosition = Offset.zero;
  Offset formPosition = Offset.zero;

  bool _isFormVisible = false;

  void _toggleFormVisibility() {
    setState(() {
      _isFormVisible = !_isFormVisible;
    });
  }

  void _handleToolBarUpdate(DragUpdateDetails details) {
    setState(() {
      toolbarPosition += details.delta;
    });
  }
  void _handleFormUpdate(DragUpdateDetails details) {
    setState(() {
      formPosition += details.delta;
    });
  }

  Widget gridForm(height){
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _width = TextEditingController();
    final TextEditingController _height = TextEditingController();

    return Container(
      width: height, //both use same value == box shape
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.blueAccent,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                "Grid Form",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                width: height * 0.8, // Adjust the width as needed
                child: TextField(
                  controller: _width,
                  decoration: InputDecoration(
                      labelText: 'Width',
                      fillColor: Colors.blueAccent,
                      filled: true,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: SizedBox(
                width: height * 0.8, // Adjust the width as needed
                child: TextField(
                  controller: _height,
                  decoration: InputDecoration(
                      labelText: 'Height',
                      fillColor: Colors.blueAccent,
                      filled: true,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: ElevatedButton(
                  onPressed: () {
                    String _widthInput = _width.text;
                    String _heightInput = _height.text;

                    print(_widthInput);
                    print(_heightInput);
                  },
                  child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
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
          color: Colors.grey[400],
        ),
        child:Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, //theres no "top" in flutter
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: FractionallySizedBox( //needs to be under a flexible widget, otherwise theres layout issues
                  widthFactor: 0.75,
                  heightFactor: 0.1,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: Colors.grey[350],
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5), // Shadow color
                          spreadRadius: 5, // Spread radius of the shadow
                          blurRadius: 7, // Blur radius of the shadow
                          offset: Offset(0, 3), // Offset of the shadow
                        ),
                      ],
                    ),
                    child: GestureDetector(
                      onTap: _toggleFormVisibility,
                      child: Icon(
                        Icons.grid_on,
                      )
                    ),
                  )
                )
              )
            ],
          )
          )
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
    if(formPosition == Offset(0,0)){//initialise form location
      formPosition = Offset(screenWidth/2, screenWidth/2);
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
              onPanUpdate: _handleToolBarUpdate,
              child: toolBar(screenWidth * 0.1, screenHeight * 0.5)
            ),
          ),
          if (_isFormVisible)
            Positioned(
              left: formPosition.dx,
              top: formPosition.dy,
              child: GestureDetector(
                onPanUpdate: _handleFormUpdate,
                child: gridForm(screenHeight * 0.25),
              )
            ),
        ],
      ),
    );
  }
}
