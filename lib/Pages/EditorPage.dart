import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_editor_app/Cubit/ColorState.dart';
import 'package:pixel_editor_app/Cubit/GridListState.dart';
import 'package:pixel_editor_app/Cubit/LayersSideBarState.dart';
import 'package:pixel_editor_app/Cubit/SelectedGridState.dart';
import 'package:pixel_editor_app/Pages/DeleteGridPage.dart';
import 'package:pixel_editor_app/Pages/LayeringPage.dart';
import 'package:pixel_editor_app/Tools/DropperTool.dart';
import '../Grid.dart';

import '../Tools/PaintTool.dart';
import '../Tools/EraseTool.dart';
import '../ResubleWidgets/CreateGrid.dart';

//PAGES
import 'Export/ExportPage.dart';
import 'ImportPage.dart';

//OTHER
import '../ColorWheel.dart';
import '../Cubit/ColorWheelState.dart';
import '../ResubleWidgets/BuildGrid.dart';
import '../ResubleWidgets/PageTransitionAnimations.dart';
import '../LayersSlider.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({Key? key}) : super(key: key);

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage>  with SingleTickerProviderStateMixin {
  PaintTool paintTool = PaintTool();
  EraseTool eraseTool = EraseTool();
  DropperTool dropperTool = DropperTool();

  bool showHud = true;
  double sizeFactor = 0.95;

  late final GridListCubit gridListCubit;
  late final SelectedGridCubit selectedGridCubit;
  late final LayersSideBarCubit layersSideBarCubit;

  late final PageTransitionAnimations pageAnimation = PageTransitionAnimations();

  late List<Widget> toolsList;

  Widget topBarButtons(Function() action, Color color, String text){
    return Expanded( //NEW GRID TOOL
      flex: 1,
      child: GestureDetector(
        onTap: action,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text(text)
            )
          )
        )
      )
    );
  }

  @override
  void initState() {
    gridListCubit = context.read<GridListCubit>(); //initialise cubits
    selectedGridCubit = context.read<SelectedGridCubit>(); 
    layersSideBarCubit = context.read<LayersSideBarCubit>();
    if(gridListCubit.state.isNotEmpty && selectedGridCubit.state == null){
      //selectedGridCubit.changeSelection(gridListCubit.state[0]);
    }
    toolsList = [paintTool, eraseTool, dropperTool];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorWheelCubit = BlocProvider.of<ColorWheelCubit>(context);
    final colorCubit = BlocProvider.of<ColorCubit>(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: showHud ? PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.10),
          child: AppBar(
          automaticallyImplyLeading: false, //need in release
          flexibleSpace: SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      topBarButtons( //NEW GRID TOOL
                        () {
                          colorWheelCubit.closeWheel();
                          Navigator.pushNamed(context, '/CreateGridPage');
                        },
                        Colors.blueAccent.shade400,
                        "Add new grid",
                      ),
                      topBarButtons( //IMPORT TOOL
                        () {
                          colorWheelCubit.closeWheel();
                          Navigator.of(context).push(
                            pageAnimation.slideUpTransition(ImportPage(previousPage: "/EditorPage"))
                          );
                        },
                        Colors.blueAccent.shade400,
                        "import"
                      ),
                      topBarButtons( //EXPORT TOOL
                        () {
                          colorWheelCubit.closeWheel();
                          Navigator.push(
                            context,
                            pageAnimation.fadeInTransition(ExportPage())
                          );
                        },
                        Colors.blueAccent.shade400,
                        "Export"
                      ),
                      topBarButtons( //DELETE BUTTON
                        (){
                          colorWheelCubit.closeWheel();
                          Navigator.push(
                            context,
                            pageAnimation.fadeInTransition(DeleteGridPage())
                          );
                        },
                        Colors.blueAccent.shade400,
                        "Delete"
                      ),
                    ]
                  ),
                ),
                Expanded( //GRID LIST IN NAV BAR
                  flex: 1,
                  child: BlocBuilder<GridListCubit, List<Grid> >( 
                    builder: (context, state) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.length,
                        itemBuilder: (context, index) {
                          final itemWidth = screenWidth / 12.0;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if(selectedGridCubit.state != state[index]){
                                  selectedGridCubit.changeSelection(index);
                                } else {
                                  selectedGridCubit.changeSelection(null);
                                }
                              });
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: itemWidth,
                                  child: Builder( //BUILDS ALL LAYERS FOR ONE GRID
                                    builder: (context) {
                                      bool currenltySelected = selectedGridCubit.state == index; 

                                      return currenltySelected ? 
                                        ListenableBuilder(
                                          listenable: state[selectedGridCubit.state!], //the currently selected grid
                                          builder: (context, child) {
                                            return Stack( 
                                              children: () {
                                              List<Widget> positionedWidgets = [];
                                              for (var layer in state[index].allLayers) { //loop through layers
                                                positionedWidgets.add(
                                                  BuildGrid(
                                                    pixelColors: layer,
                                                    selected: true,
                                                    widthFactor: 0.9,
                                                    heightFactor: 0.9
                                                  )
                                                ); 
                                              }
                                              return positionedWidgets;
                                              }(),
                                            );
                                          }
                                        )
                                      : Stack( 
                                          children: () {
                                          List<Widget> positionedWidgets = [];
                                          for (var layer in state[index].allLayers) { //loop through layers
                                            positionedWidgets.add(
                                              BuildGrid(
                                                pixelColors: layer,
                                                selected: false,
                                                widthFactor: 0.9,
                                                heightFactor: 0.9
                                              )
                                            ); 
                                          }
                                          return positionedWidgets;
                                          }(),
                                        );
                                      
                                    }
                                  )
                                ),
                              ],
                            )
                          );
                        }
                      );
                    }
                  )
                )
              ]
            )
          ),
        ),
      ): null,
      body: Row(
        children: [
          Expanded( 
            flex: 2,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned( //UNDO AND REDO BUTTON
                  top: 0, //the numbers represent the distance between the parents and child, i think
                  left: 0, //so 0 means, take up the entire space, no distance
                  right: 0,
                  child: Align(
                    alignment: Alignment.center,
                    child: BlocBuilder<SelectedGridCubit, int?>(
                      builder: (context, state) {
                        if (state != null) { //IF A GRID IS SELECTED
                          return ListenableBuilder( //REBUILD TO CHANGE OPACITY OF UNDO/REDO BUTTONS
                            listenable: gridListCubit.state[selectedGridCubit.state!], //CURRENTLY SELECTED GRID
                            builder: (context, child) {
                              final grid = gridListCubit.state[selectedGridCubit.state!];
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Opacity(
                                    opacity: grid.backPossible() ? 1 : 0.5,
                                    child: IconButton(
                                      onPressed: () {
                                        gridListCubit.state[selectedGridCubit.state!].back();
                                      },
                                      icon: Icon(Icons.undo),
                                    ),
                                  ),
                                  Opacity(
                                    opacity: grid.forwardPossible() ? 1 : 0.5,
                                    child: IconButton(
                                      onPressed: () {
                                        gridListCubit.state[selectedGridCubit.state!].forward();
                                      },
                                      icon: Icon(Icons.redo),
                                    ),
                                  )
                                ],
                              );
                            }
                          );
                        }
                        else {
                          return Container();
                        }
                      }
                    )
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: 0.6,
                  child: ColorWheel(), 
                )
                /*Positioned( //Slider width is minimum 144 pixelss
                  left: 0,
                  top: 0,
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      trackHeight: 10,
                    ),
                    child: Slider( //make this adaptive so it changes depending on the platform
                      value: sizeFactor,
                      min: 0.2,
                      max: 1.0,
                      onChanged: (double newValue) {
                        setState(() {
                          sizeFactor = newValue;
                        });
                      },
                    ),
                  )
                ),*/
              ],
            ), 
          ),
          Expanded( 
            flex: 8,
            child: Center(
              child: InteractiveViewer( //ALLOWS USER TO ZOOM INTO GRID
                child: BlocBuilder<SelectedGridCubit, int?>(
                  builder: (context, state) {
                    if (state != null) {
                      return ListenableBuilder( 
                        listenable: gridListCubit.state[state],
                        builder: (context, child) {
                          //print("rebuilding grid");
                          return Stack(
                            children: () {
                              List<Widget> positionedWidgets = [];
                              Grid selected = gridListCubit.state[state];
                              for (var layer in selected.allLayers) {
                                //print("getting layer");
                                if (selected.isViewable(layer)) {
                                  //print("viewable");
                                  if (selected.isEditable(layer)) {
                                    positionedWidgets.add(
                                      CreateGrid( 
                                        layer: selected,
                                        widthFactor: sizeFactor,
                                        heightFactor: sizeFactor,
                                      ),
                                    );
                                  } else {
                                    positionedWidgets.add(
                                      IgnorePointer( 
                                        child: BuildGrid(
                                          pixelColors: layer,
                                          includeOpacity: true,
                                          widthFactor: sizeFactor,
                                          heightFactor: sizeFactor,
                                        ),
                                      ),
                                    );
                                  }
                                }
                              }
                              return positionedWidgets;
                            }(),
                          );
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
            )
          ),
          Expanded( 
            flex: 1,
            child: Stack(
              fit: StackFit.expand,
              children: [
                Positioned(
                  top: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton( 
                        onPressed: () {
                          setState(() {
                            showHud = !showHud;
                          });
                        },
                        icon: Icon(Icons.remove_red_eye_sharp),
                      ),
                      IconButton( 
                        onPressed: () {
                          layersSideBarCubit.toggleSideBar();
                        },
                        icon: Icon(Icons.layers),
                      ),
                    ],
                  ),
                ),
                LayersSlider(),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar( ////BOTTOM BAR
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded( //SHOWS CURRENT COLOR 
              flex: 2,
              child: BlocBuilder<ColorCubit, Color>(
                builder: (context, state) {
                  return Container(
                    color: colorCubit.state,
                  );
                }
              )
            ),
            Expanded( //GO TO LAYERING PAGE
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: GestureDetector(
                  onTap: () {
                    if(selectedGridCubit.state == null){
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Center(
                            child: Text(
                              'Cannot open layers page, no grid currently selected'
                            )
                          ),
                        ),
                      );
                    } else {
                      colorWheelCubit.closeWheel();
                      Navigator.of(context).push(
                        pageAnimation.slideUpTransition(
                          LayeringPage(
                            //grid: gridListCubit.state[selectedGridCubit.state!]
                            gridIndex: selectedGridCubit.state!,
                          )
                        )
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.layers,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded( //OPEN COLOR WHEEL SIDE BAR
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: GestureDetector(
                  onTap: () {
                    colorWheelCubit.toggleColorWheel();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.color_lens,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded( //DUPLICATE GRID
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: GestureDetector(
                  onTap: () {
                    gridListCubit.addGrid(
                      gridListCubit.state[selectedGridCubit.state!].clone()
                    );
                    selectedGridCubit.changeSelection(gridListCubit.state.length - 1);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.copy,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded( //LIST OF TOOLS
              flex: 8,
              child: LayoutBuilder(
                builder:(context, constraints) {  
                  final buttonWidth = constraints.maxWidth / toolsList.length; 
                  return Row(
                    children: [
                      Expanded(
                        child: Icon(Icons.arrow_back),
                      ),
                      Expanded(
                        flex: 8,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: toolsList.length,
                          itemBuilder: (context, index) {
                            return SizedBox(
                              width: buttonWidth,
                              child: toolsList[index],
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: Icon(Icons.arrow_forward),
                      ),
                    ],
                  );
                }
              ),
            )
          ],
        )
      )
    );
  }
}