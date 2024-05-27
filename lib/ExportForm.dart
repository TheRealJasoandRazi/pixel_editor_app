import 'dart:html';
import 'package:pixel_editor_app/Cubit/ExportSelectionState.dart';

import 'CreateGrid.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pixel_editor_app/Cubit/ExportState.dart';
import 'Cubit/GridListState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'dart:io'; //unused



class ExportForm extends StatefulWidget {
  const ExportForm({super.key});

  @override
  State<ExportForm> createState() => _ExportFormState();
}

class _ExportFormState extends State<ExportForm> {
  Offset formPosition = Offset(0,0);
  double size = 0;

  late final ExportSelectionCubit exportSelectionCubit;

  void _handleFormUpdate(DragUpdateDetails details) {
    setState(() {
      formPosition += details.delta;
    });
  }

  @override
  void initState() {
    super.initState();
    exportSelectionCubit = context.read<ExportSelectionCubit>(); //initialise cubit
  }

  @override
  void dispose(){
    super.dispose();
    exportSelectionCubit.clearList(); //empty list when closing export form
  }

Future<Uint8List> captureWidget(GlobalKey globalKey) async { //create image
  final RenderRepaintBoundary? boundary = globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

  if (boundary != null) {
    final ui.Image image = await boundary.toImage();
  
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  
    if (byteData != null) {
      final Uint8List pngBytes = byteData.buffer.asUint8List();
      return pngBytes;
    } else {
      throw Exception('ByteData is null');
    }
  } else {
    throw Exception('RenderRepaintBoundary not found');
  }
}

  Future<void> _saveSelectedWidgets(List<GlobalKey> selectedKeys) async {
    for (final key in selectedKeys) {
      try {
        Uint8List capturedImage = await captureWidget(key);
        // Here you can do whatever you want with the captured image.
        // For demonstration, let's print its length.
        print('Captured image length: ${capturedImage.length}');
      } catch (e) {
        print('Failed to capture widget: $e');
      }
    }
  }

  Widget replica(CreateGrid grid, bool selected){
    return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? Colors.blueAccent : Colors.grey.shade400,
            width: 2.0, // Width of the border
          ),
        ),
        child: ScrollConfiguration( //ensures there are no scrollbars in the gridview
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(), // Disable scrolling
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: grid.width, // Number of columns
            ),
            itemCount: grid.width * grid.height,
            itemBuilder: (context, index) {
              int rowIndex = index ~/ grid.width;
              int columnIndex = index % grid.width;

              Color color = grid.pixelColors[rowIndex][columnIndex];

              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  color: color,
                ),
              );
            },
          ),
        ),
      );
  }
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final gridListCubit = BlocProvider.of<GridListCubit>(context);
    final exportFormCubit = BlocProvider.of<ExportCubit>(context);

    if(size == 0){
      size = screenHeight * 0.25;
    }

    if(formPosition == Offset(0,0)){//initialise form location
      formPosition = Offset(screenWidth/2, screenWidth/2);
    }

    int stateLength = gridListCubit.state.length;

    return Stack( 
      children: [
        Positioned(
          left: formPosition.dx + size,
          top: formPosition.dy - 10,
          child: GestureDetector( //adjusts size of form
            onPanUpdate: (details) {
              setState(() { 
                size += details.delta.dx; 
                size = size.clamp(screenWidth * 0.25, screenWidth * 0.50); //add constraints
              }); 
            },
            child: Icon(
              Icons.arrow_outward
            ),
          )
        ),
        Positioned(
          left: formPosition.dx,
          top: formPosition.dy,
          child: GestureDetector(
            onPanUpdate: _handleFormUpdate,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.grey.shade300
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: size * 0.8,
                    width: size * 0.9,
                    child: stateLength > 0 //if theres grids available
                      ? ScrollConfiguration( //create grids
                          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                          child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(), // Disable scrolling
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, // Number of columns
                              crossAxisSpacing: 10.0, // Spacing between columns
                              mainAxisSpacing: 10.0, // Spacing between rows
                            ),
                            itemCount: gridListCubit.state.length,
                            itemBuilder: (context, index) {
                              var grid = gridListCubit.state[index];
                              GlobalKey key = GlobalKey(); // Create a GlobalKey for each widget
                              return GestureDetector(
                                onTap: () {
                                  if (exportSelectionCubit.containsKey(key)) {
                                    exportSelectionCubit.removeSelectedKey(key); // Deselect if already selected
                                  } else {
                                    exportSelectionCubit.addKey(key); // Select if not selected
                                  }
                                },
                                child: BlocBuilder<ExportSelectionCubit, List<GlobalKey>>( //rebuilds only the replica whenever state changes
                                  builder: (context, state) {
                                    return RepaintBoundary( 
                                      key: key,
                                      child: replica(grid, state.contains(key)),
                                    );
                                  },
                                )
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Text(
                            "No Grids Available",
                          ),
                        ),
                  ),
                  SizedBox( // export button
                    width: size * 0.6, // Adjust width as needed
                    height: size * 0.2, // Adjust height as needed
                    child: GestureDetector(
                      onTap: () {
                        print("export button clicked");
                        _saveSelectedWidgets(exportSelectionCubit.state);
                        exportFormCubit.changeExportFormVisibility();
                      },
                      child: Padding(
                        padding: EdgeInsets.all(10.0), // Adjust padding as needed
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(15.0), // Adjust border radius as needed
                          ),
                          child: Center(
                            child: Text("Export"),
                          )
                        ),
                      ),
                    ),
                  ),
                ],
              )
            )
          )
        )
      ]
    );
  } 
}