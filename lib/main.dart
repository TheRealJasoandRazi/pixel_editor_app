import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isFormVisible = false;
  void _updateFormVisibility() {
  setState(() {
    _isFormVisible = !_isFormVisible;
  });
}

  _GridToolState tool = _GridToolState();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
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
          CustomToolBar(
            screenWidth: screenWidth, 
            screenHeight: screenHeight, 
            ypos: screenHeight / 4,
          ),
          //movable form
          if (tool.isFormVisibile)
            Positioned(
              left: tool.formPosition.dx,
              top: tool.formPosition.dy,
              child: GestureDetector(
                onPanUpdate: tool._handleFormUpdate,
                child: tool.gridForm(screenWidth, screenHeight),
              )
            ),
        ],
      ),
    );
  }

}
/////////////CUSTOM TOOLBAR CLASS/////////////////////////
class CustomToolBar extends StatefulWidget {
    final double screenWidth;
    final double screenHeight;
    final double ypos;

    CustomToolBar({
        required this.screenWidth,
        required this.screenHeight,
        required this.ypos,
    });

    @override
    _CustomToolBarState createState() => _CustomToolBarState();
}

class _CustomToolBarState extends State<CustomToolBar> {
    Offset toolbarPosition = Offset.zero;

    @override
    initState() {
      super.initState();
      toolbarPosition = Offset(0, widget.ypos);
    }

    void _handleToolBarUpdate(DragUpdateDetails details) {
      setState(() {
        toolbarPosition += details.delta;
      });
    }

    @override
    Widget build(BuildContext context) {
      double width = widget.screenWidth * 0.1;
      double height = widget.screenHeight * 0.5;

      double threshold = widget.screenHeight * 0.05;
      double lowerThreshold = widget.screenHeight - threshold - height;
      bool rotatedBar = false;

      if(toolbarPosition.dy <= threshold || toolbarPosition.dy >= lowerThreshold)
      {
        rotatedBar = true;
      } else {
        rotatedBar = false;
      }

        return Positioned(
            left: toolbarPosition.dx,
            top: toolbarPosition.dy,
            child: GestureDetector(
                onPanUpdate: _handleToolBarUpdate,
                child: AnimatedRotation(
                    turns: rotatedBar ? 0.25 : 0, 
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    child: Container(
                        width: width,
                        height: height,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: Colors.grey[400],
                        ),
                        child: Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                    //toolBarButton(Icons.grid_on, widget.toggleFormVisibility, Colors.grey.shade300),
                                    GridTool(),
                                    PaintTool(),
                                ],
                            ),
                        ),
                    ),
                ),
            ),
        );
    }
}

///////////////MIXIN CLASS//////////////////
mixin ToolBarButtons {
  Widget toolBarButton(IconData icon, Function() action, Color color) {
    return Flexible(
      flex: 1,
      child: FractionallySizedBox(
        widthFactor: 0.75,
        heightFactor: 0.2,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: color,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: action,
              child: Icon(
                icon,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
//////////////////////PAINT TOOL CLASS//////////////////////
class PaintTool extends StatefulWidget with ToolBarButtons {

  @override
  _PaintToolState createState() => _PaintToolState();
}

class _PaintToolState extends State<PaintTool> {
  bool paintSelected = false;
  Color buttonColor = Colors.grey.shade300;

  void _togglePaintButton() {
    setState(() {
      paintSelected = !paintSelected;
      buttonColor = paintSelected ? Colors.blue.shade300 : Colors.grey.shade300;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Call the inherited toolBarButton function to create the toolbar button
    return widget.toolBarButton(
      Icons.format_paint,
      _togglePaintButton,
      buttonColor,
    );
  }
}
////////////////GRID TOOL CLASS///////////////////
class GridTool extends StatefulWidget with ToolBarButtons{

  /*final double screenWidth;
  final double screenHeight;

  GridTool({
      required this.screenWidth,
      required this.screenHeight,
  });*/

  @override
  _GridToolState createState() => _GridToolState();
}

class _GridToolState extends State<GridTool> {
  Offset formPosition = Offset(0,0);
  bool _isFormVisible = false;

  @override
  void initState() {
    super.initState();
  }

  void _toggleFormVisibility() {
    setState(() {
      _isFormVisible = !_isFormVisible;
    });
    print(_isFormVisible);
  }

  void _handleFormUpdate(DragUpdateDetails details) {
    setState(() {
      formPosition += details.delta;
    });
  }

  bool get isFormVisibile => _isFormVisible;

  Widget gridForm(screenWidth, screenHeight){
    //final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    final TextEditingController _width = TextEditingController();
    final TextEditingController _height = TextEditingController();
    formPosition = Offset(screenWidth/2, screenHeight/2);
    double height = screenHeight * 0.25;

    return Container(
      width: height, //both use same value == box shape
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        color: Colors.blueAccent,
      ),
      child: Form(
        //key: _formKey,
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

                    print(_widthInput); //for testing
                    print(_heightInput);

                    _toggleFormVisibility();
                  },
                  child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return widget.toolBarButton(
      Icons.grid_on,
      _toggleFormVisibility,
      Colors.grey.shade300,
    );
  }
}

