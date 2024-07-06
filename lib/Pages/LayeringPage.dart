import 'package:flutter/material.dart';
import 'package:pixel_editor_app/ResubleWidgets/BuildGrid.dart';
import '../Layers.dart';
import '../ResubleWidgets/SnackBarMessage.dart';

class LayeringPage extends StatefulWidget {
  final Layers initialListOfLayers;

  const LayeringPage({
    super.key,
    required this.initialListOfLayers,
  });

  @override
  State<LayeringPage> createState() => _LayeringPageState();
}

class _LayeringPageState extends State<LayeringPage> {
  late bool showDeleteButton;

  @override
  void initState() {
    super.initState();
    showDeleteButton = false;
  }

  double? buttonWidth;
  double? buttonHeight;

 Widget layer(int index) {
  List<List<Color>> layer = widget.initialListOfLayers.allLayers[index];

  return Stack(
    children: [
      Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blue),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  AnimatedPositioned(
                    duration: Duration(milliseconds: 300),
                    left: showDeleteButton ? 60 : 0,
                    top: 0,
                    right: showDeleteButton ? 0 : 0,
                    bottom: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                      ),
                      child: LayoutBuilder( //use to set one size that wont be changed for the edit and view button, its so when the delete button shows up, the buttons will stay the same size
                        builder: (context, constraints) {
                          if(buttonHeight == null && buttonWidth == null){
                            buttonHeight = constraints.maxHeight * 0.4;
                            buttonWidth = constraints.maxWidth * 0.5;
                          }
                          return Column( //VIEW AND EDIT BUTTON
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    widget.initialListOfLayers.changeEditable(layer);
                                  });
                                },
                                child: Opacity(
                                  opacity: widget.initialListOfLayers.isEditable(layer) ? 1.0 : 0.5,
                                  child: Container(
                                    width: buttonWidth, 
                                    height: buttonHeight, 
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Center(
                                      child: Icon(Icons.edit),
                                    ),
                                  ),
                                ),
                              ),
                            
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (widget.initialListOfLayers.isViewable(layer)) {
                                      widget.initialListOfLayers.removeView(layer);
                                    } else {
                                      widget.initialListOfLayers.addView(layer);
                                    }
                                  });
                                },
                                child: Opacity(
                                  opacity: widget.initialListOfLayers.isViewable(layer) ? 1.0 : 0.5,
                                  child: Container(
                                    width: buttonWidth, 
                                    height: buttonHeight,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: Center(
                                      child: Icon(Icons.remove_red_eye),
                                    ),
                                  ),
                                )
                              ), 
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.pink),
                ),
                child: BuildGrid(
                  pixelColors: layer,
                  heightFactor: 0.9,
                  widthFactor: 0.9,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.pink),
                ),
                child: Center(
                  child: Text("Editable Layer Text"),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                onPressed: () {
                  print("open menu");
                },
                icon: Icon(Icons.menu),
              ),
            ),
          ],
        ),
      ),
      AnimatedPositioned(
        duration: Duration(milliseconds: 300),
        left: showDeleteButton ? 0 : -60,
        top: 0,
        bottom: 0,
        child: GestureDetector(
          onTap: () {
            setState(() {
              if (widget.initialListOfLayers.allLayers.length > 1) {
                widget.initialListOfLayers.removeLayer(layer);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Center(
                      child: Text(
                        'Cannot delete the last layer, otherwise it will delete the grid entirely',
                      ),
                    ),
                  ),
                );
              }
            });
          },
          child: Container(
            color: Colors.red,
            width: 60,
            alignment: Alignment.center,
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ],
  );
}




  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.initialListOfLayers.allLayers.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.30,
                     child: layer(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    widget.initialListOfLayers.addLayer();
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Row(
                      children:[
                        Icon(
                          Icons.layers
                        ),
                        Icon(
                          Icons.add
                        )
                      ]
                    )
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    showDeleteButton = !showDeleteButton;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.layers),
                        Text( //need to find an icon for this
                          "-",
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: 20.0,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/EditorPage");
                },
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Edit Page"),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
