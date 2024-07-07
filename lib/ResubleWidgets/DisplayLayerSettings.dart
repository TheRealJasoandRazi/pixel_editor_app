import 'package:flutter/material.dart';
import '../Grid.dart';
import '../Cubit/DeleteButtonState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../ResubleWidgets/BuildGrid.dart';

import 'package:flutter/cupertino.dart'; //apple style widgets

class DisplayLayerSettings extends StatefulWidget {
  final int layerIndex; //layer your modifying
  final Grid grid; //grid used to do checks
  
  const DisplayLayerSettings({
    super.key,
    required this.layerIndex,
    required this.grid
  });

  @override
  State<DisplayLayerSettings> createState() => _DisplayLayerSettingsState();
}

class _DisplayLayerSettingsState extends State<DisplayLayerSettings> {
  double? buttonWidth;
  double? buttonHeight;

  late Layer layer;
  late Grid grid;
  late bool showMenu;

  @override
  void initState() { //only runs once
    layer = widget.grid.allLayers[widget.layerIndex];
    grid = widget.grid;
    showMenu = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    layer = widget.grid.allLayers[widget.layerIndex]; //update layer everytime layer is rendered

    return Column(
      children: [
        Expanded(
          flex: 3,
        child:Stack(
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
                      BlocBuilder<DeleteButtonCubit, bool>( //WHEN TRUE, ANIMATE EDIT AND VIEW BUTTONS
                        builder:(context, state) {
                          return AnimatedPositioned(
                            duration: Duration(milliseconds: 300),
                            left: state ? 60 : 0,
                            top: 0,
                            right: state ? 0 : 0,
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
                                    GestureDetector( //EDIT BUTTON
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
                                    GestureDetector( //VIEW BUTTON
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
                                      )
                                    ), 
                                    ],
                                  );
                                }
                              ),
                            ),
                          );
                        }
                      )
                    ],
                  ),
                ),
                Expanded( //DISPLAY GRID
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.pink),
                    ),
                    child: Opacity(
                      opacity: layer.opacity,
                      child: BuildGrid(
                        pixelColors: layer,
                        heightFactor: 1,
                        widthFactor: 0.9,
                      ),
                    )
                  ),
                ),
                Expanded( //EDITABLE TEXT
                  flex: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.pink),
                    ),
                    child: Center(
                      /*child: Text(
                        layer.name
                      ),*/
                      child: Text(
                        layer.name
                      )
                    ),
                  ),
                ),
                Expanded( //MENU BUTTON
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
          BlocBuilder<DeleteButtonCubit, bool>( //DELETE BUTTON
            builder:(context, state) {
              return AnimatedPositioned( //SHOWS THE DELETE BUTTON
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
            }
          )
        ],
      )
    ),
      Expanded( //MENU POP UP
        flex: 1,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.pink)
          ),
          child: Stack(
            children: [
              AnimatedPositioned(
                duration: Duration(milliseconds: 300),
                left: 0,
                top: showMenu ? 0 : -60, // Slide into view
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center, //I dont this does much
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column( //OPACITY CHANGE
                            children: [
                              Text(
                                "Opacity",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white
                                ),
                              ),
                              Slider(
                                value: layer.opacity, 
                                onChanged: (newValue){
                                  setState(() {
                                    layer.opacity = newValue;
                                  });
                                }
                              ),
                            ]
                          ),
                        ),
                        Expanded( //NEW NAME INPUT
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
                          )
                        ),
                        Expanded( //SWAP LAYERS BUTTON
                          child: IconButton(
                            onPressed: (){
                              showCupertinoModalPopup( //APPLE ACTION BUTTON MENU
                                context: context,
                                builder: (BuildContext context) => CupertinoActionSheet(
                                  title: Text('Swap Layers'),
                                  actions: <Widget>[
                                    CupertinoActionSheetAction(
                                      child: Text('Swap With Layer Above'),
                                      onPressed: () {
                                        grid.swapLayers(layer, "up");
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    CupertinoActionSheetAction(
                                      child: Text('Swap With Layer Below'),
                                      onPressed: () {
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
                        Expanded( //MERGE LAYERS BUTTON
                          child: IconButton(
                            onPressed: (){
                              showCupertinoModalPopup( //APPLE ACTION BUTTON MENU
                                context: context,
                                builder: (BuildContext context) => CupertinoActionSheet(
                                  title: Text('Swap Layers'),
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
                        )
                      ]
                    )
                  ),
                ),
              )
            ]
          ),
        )
      )
      ]
    );
  }
}