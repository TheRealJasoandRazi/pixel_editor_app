import 'package:flutter/material.dart';
import '../Grid.dart';
import '../Cubit/DeleteButtonState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'BuildGrid.dart';
import 'package:flutter/cupertino.dart'; // Apple style widgets

class DisplayLayerSettings extends StatefulWidget {
  final int layerIndex; // Layer you're modifying
  final Grid grid; // Grid used to do checks
  
  const DisplayLayerSettings({
    Key? key,
    required this.layerIndex,
    required this.grid,
  }) : super(key: key);

  @override
  _DisplayLayerSettingsState createState() => _DisplayLayerSettingsState();
}

class _DisplayLayerSettingsState extends State<DisplayLayerSettings> {
  double? buttonWidth;
  double? buttonHeight;

  late Layer layer;
  late Grid grid;
  late bool showMenu;

  @override
  void initState() {
    super.initState();
    layer = widget.grid.allLayers[widget.layerIndex];
    grid = widget.grid;
    showMenu = false;
  }

  @override
  Widget build(BuildContext context) {
    layer = widget.grid.allLayers[widget.layerIndex]; // Update layer every time the widget is rendered

    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Stack(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                    bottomLeft: Radius.zero,
                    bottomRight: Radius.zero,
                  ),
                ),
                elevation: 4,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Stack(
                        children: [
                          BlocBuilder<DeleteButtonCubit, bool>(
                            builder: (context, state) {
                              return AnimatedPositioned(
                                duration: Duration(milliseconds: 300),
                                left: state ? 60 : 0,
                                top: 0,
                                right: 0,
                                bottom: 0,
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    if(buttonHeight == null && buttonWidth == null) {
                                      buttonHeight = constraints.maxHeight * 0.4;
                                      buttonWidth = constraints.maxWidth * 0.5;
                                    }
                                    return Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector( // Edit button
                                          onTap: () {
                                            grid.changeEditable(layer);
                                          },
                                          child: Opacity(
                                            opacity: grid.isEditable(layer) ? 1.0 : 0.5,
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
                                        GestureDetector( // View button
                                          onTap: () {
                                            setState(() {
                                              if(!grid.isEditable(layer)){
                                                if (grid.isViewable(layer)) {
                                                  grid.removeView(layer);
                                                } else {
                                                  grid.addView(layer);
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Center(
                                                      child: const Text("Cannot hide a layer while it is editable"),
                                                    ),
                                                  ),
                                                );
                                              }
                                            });
                                          },
                                          child: Opacity(
                                            opacity: grid.isViewable(layer) ? 1.0 : 0.5,
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
                                          ),
                                        ), 
                                      ],
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded( // Display grid
                      flex: 4,
                      child: Opacity(
                        opacity: layer.opacity,
                        child: BuildGrid(
                          pixelColors: layer,
                          heightFactor: 1,
                          widthFactor: 0.9,
                        ),
                      ),  
                    ),
                    Expanded( // Editable text
                      flex: 1,
                      child: Center(
                        child: Text(
                          layer.name,
                        ),
                      ),
                    ),
                    Expanded( // Menu button
                      flex: 1,
                      child: IconButton(
                        onPressed: () {
                          setState(() {
                            showMenu = !showMenu;
                          });
                        },
                        icon: Icon(Icons.menu),
                      ),
                    ),
                  ],
                ),
              ),
              BlocBuilder<DeleteButtonCubit, bool>( // Delete button
                builder: (context, state) {
                  return AnimatedPositioned(
                    duration: Duration(milliseconds: 300),
                    left: state ? 0 : -60,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          if (grid.allLayers.length > 1) {
                            grid.removeLayer(layer);
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
                  );
                },
              ),
            ],
          ),
        ),
        Expanded( // Menu popup
          flex: 1,
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: Duration(milliseconds: 300),
                  left: 0,
                  top: showMenu ? 0 : -100, // Slide into view
                  /*child: LayerMenu(
                    grid: widget.grid,
                    layerIndex: widget.layerIndex,
                  ),*/
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.zero,
                        topRight: Radius.zero,
                        bottomLeft: Radius.circular(12.0),
                        bottomRight: Radius.circular(12.0),
                      ),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 3,
                              child: Column( // Opacity change
                                children: [
                                  Text(
                                    "Opacity",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Slider(
                                    value: layer.opacity, 
                                    onChanged: (newValue){
                                      setState(() {
                                        layer.opacity = newValue;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            Expanded( // New name input
                              flex: 2,
                              child: TextField(
                                decoration: InputDecoration(
                                  hintText: 'Enter new layer name', 
                                ),
                                onChanged: (text) {
                                  setState(() {
                                    layer.changeName(text);
                                  });
                                },
                              ),
                            ),
                            Expanded( // Swap layers button
                              child: IconButton(
                                onPressed: (){
                                  showCupertinoModalPopup( // Apple action button menu
                                    context: context,
                                    builder: (BuildContext context) => CupertinoActionSheet(
                                      title: Text('Swap Layers'),
                                      actions: <Widget>[
                                        CupertinoActionSheetAction(
                                          child: Text('Swap With Layer Above'),
                                          onPressed: () {
                                            //showMenu = !showMenu; //when swapping layers, close menu, another solution is better
                                            grid.swapLayers(layer, "up");
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        CupertinoActionSheetAction(
                                          child: Text('Swap With Layer Below'),
                                          onPressed: () {
                                            //showMenu = !showMenu;
                                            grid.swapLayers(layer, "down");
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                      cancelButton: CupertinoActionSheetAction(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.swap_calls,
                                ),
                              ),
                            ),
                            Expanded( // Merge layers button
                              child: IconButton(
                                onPressed: (){
                                  showCupertinoModalPopup( // Apple action button menu
                                    context: context,
                                    builder: (BuildContext context) => CupertinoActionSheet(
                                      title: Text('Merge Layers'),
                                      actions: <Widget>[
                                        CupertinoActionSheetAction(
                                          child: Text('Merge Above'),
                                          onPressed: () {
                                            grid.mergeLayers(layer, "up");
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                        CupertinoActionSheetAction(
                                          child: Text('Merge Below'),
                                          onPressed: () {
                                            grid.mergeLayers(layer, "down");
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                      cancelButton: CupertinoActionSheetAction(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.merge,
                                ),
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                onPressed: (){
                                  if(grid.width == grid.height){
                                    grid.rotateLayer(layer);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Center(
                                          child: Text(
                                            "Cannot rotate layer when the width and height are different",
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                icon: Icon(
                                  Icons.rotate_right,          
                                ),
                              ),
                            ),
                            Expanded(
                              child: IconButton(
                                onPressed: (){
                                  grid.reflectLayer(layer);
                                },
                                icon: Icon(
                                  Icons.arrow_back_ios,         
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ),
              ],
            ),
          ),
    
      ],
    );
  }
}

class LayerMenu extends StatefulWidget {
  final int layerIndex;
  final Grid grid;

  const LayerMenu({
    super.key,
    required this.layerIndex,
    required this.grid,
  });

  @override
  _LayerMenuState createState() => _LayerMenuState();
}

class _LayerMenuState extends State<LayerMenu> {
  late Layer layer;

  @override
  void initState() {
    super.initState();
    //layer = widget.grid.allLayers[widget.layerIndex];
  }

  @override
  Widget build(BuildContext context) {
    layer = widget.grid.allLayers[widget.layerIndex]; 

    return Container(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Text(
                    "Opacity",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Slider(
                    value: layer.opacity,
                    onChanged: (newValue) {
                      setState(() {
                        layer.opacity = newValue;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter new layer name',
                ),
                onChanged: (text) {
                  setState(() {
                    layer.changeName(text);
                  });
                },
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) => CupertinoActionSheet(
                      title: Text('Swap Layers'),
                      actions: <Widget>[
                        CupertinoActionSheetAction(
                          child: Text('Swap With Layer Above'),
                          onPressed: () {
                            widget.grid.swapLayers(layer, "up");
                            Navigator.of(context).pop();
                          },
                        ),
                        CupertinoActionSheetAction(
                          child: Text('Swap With Layer Below'),
                          onPressed: () {
                            widget.grid.swapLayers(layer, "down");
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                      cancelButton: CupertinoActionSheetAction(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.swap_calls,
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (BuildContext context) => CupertinoActionSheet(
                      title: Text('Merge Layers'),
                      actions: <Widget>[
                        CupertinoActionSheetAction(
                          child: Text('Merge Above'),
                          onPressed: () {
                            widget.grid.mergeLayers(layer, "up");
                            Navigator.of(context).pop();
                          },
                        ),
                        CupertinoActionSheetAction(
                          child: Text('Merge Below'),
                          onPressed: () {
                            widget.grid.mergeLayers(layer, "down");
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                      cancelButton: CupertinoActionSheetAction(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.merge,
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () {
                  if (widget.grid.width == widget.grid.height) {
                    widget.grid.rotateLayer(layer);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(
                          child: Text(
                            "Cannot rotate layer when the width and height are different",
                          ),
                        ),
                      ),
                    );
                  }
                },
                icon: Icon(
                  Icons.rotate_right,
                ),
              ),
            ),
            Expanded(
              child: IconButton(
                onPressed: () {
                  widget.grid.reflectLayer(layer);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
