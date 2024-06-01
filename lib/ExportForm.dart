import 'package:pixel_editor_app/Cubit/ExportSelectionState.dart';
import 'package:pixel_editor_app/Cubit/TestState.dart';
import 'package:share/share.dart';
import 'package:path_provider/path_provider.dart';


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
import 'dart:html' as html;

import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ExportForm extends StatefulWidget {
  const ExportForm({super.key});

  @override
  State<ExportForm> createState() => _ExportFormState();
}

class _ExportFormState extends State<ExportForm> {
  Offset formPosition = Offset(0,0);
  double size = 0;

  late final ExportSelectionCubit exportSelectionCubit;
  List<GlobalKey> keyList = []; //test

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

  Future<void> saveImageMobile(Uint8List imageData) async {
    final result = await ImageGallerySaver.saveImage(imageData);
    print(result);
  }

  void saveImageWeb(Uint8List capturedImage) {
    final blob = html.Blob([capturedImage]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    
    // Open the data URL in a new browser tab
    html.AnchorElement(href: url)
      ..setAttribute('download', 'captured_image.png')
      ..click();
      
      // Revoke the object URL to release memory
    html.Url.revokeObjectUrl(url);
  }

Future<Uint8List> captureWidget(GlobalKey globalKey) async { //create image
  final RenderRepaintBoundary? boundary = globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

  if (boundary != null) {
    final ui.Image image = await boundary.toImage(pixelRatio: 10);
  
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

      if (kIsWeb) {
        saveImageWeb(capturedImage);
      } else {
        saveImageMobile(capturedImage);
      }
    } catch (e) {
      print('Failed to capture and share widget: $e');
    }
  }
}


  Widget replica(CreateGrid grid, bool selected, bool exporting){
    return Container(
        decoration: BoxDecoration(
          border: exporting ? null : Border.all(
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
                  border: exporting ? null : Border.all(color: Colors.grey.shade400),
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

    int gridstateLength = gridListCubit.state.length;
    //int selectedstateLength = exportSelectionCubit.state.length;

    return Stack(
      children: [
        Positioned(
          left: formPosition.dx + (size * 2),
          top: formPosition.dy - 10,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                size += details.delta.dx;
                size = size.clamp(screenWidth * 0.25, screenWidth * 0.50);
              });
            },
            child: Icon(Icons.arrow_outward),
          ),
        ),
        Positioned(
          left: formPosition.dx,
          top: formPosition.dy,
          child: GestureDetector(
            onPanUpdate: _handleFormUpdate,
            child: Row(
              children: [
                Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: size * 0.8,
                        width: size * 0.9,
                        child: gridstateLength > 0
                            ? ScrollConfiguration(
                                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                                child: GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10.0,
                                    mainAxisSpacing: 10.0,
                                  ),
                                  itemCount: gridListCubit.state.length,
                                  itemBuilder: (context, index) {
                                    var grid = gridListCubit.state[index];
                                    return GestureDetector(
                                      onTap: () {
                                        if (exportSelectionCubit.containsGrid(grid)) {
                                          exportSelectionCubit.removeSelectedGrid(grid);
                                        } else {
                                          exportSelectionCubit.addGrid(grid);
                                        }
                                      },
                                      child: BlocBuilder<ExportSelectionCubit, List<CreateGrid>>(
                                        builder: (context, state) {
                                          return replica(grid, state.contains(grid), false);
                                        },
                                      ),
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
                      SizedBox(
                        width: size * 0.6,
                        height: size * 0.2,
                        child: GestureDetector(
                          onTap: () async {
                            print("export button clicked");
                            print(keyList.length);
                            print(keyList);
                            _saveSelectedWidgets(keyList);
                            exportFormCubit.changeExportFormVisibility();
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Center(
                                child: Text("Export"),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container( // Second container that will show borderless grid
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                  ),
                  child: BlocBuilder<ExportSelectionCubit, List<CreateGrid>>( // Rebuilds entire grid
                    builder: (context, state) {
                      keyList.clear(); // Resets list on every update
                      return state.length > 0
                          ? Column(
                            children: [
                              SizedBox(
                                width: size * 0.9,
                                height: size * 0.2,
                                child: Center(
                                  child: Text("Previews")
                                )
                              ),
                              SizedBox(
                                width: size * 0.9,
                                height: size * 0.8,
                                child: ScrollConfiguration(
                                  behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                                  child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 10.0,
                                      mainAxisSpacing: 10.0,
                                    ),
                                    itemCount: state.length,
                                    itemBuilder: (context, index) {
                                      var grid = state[index];
                                      GlobalKey key = GlobalKey(); // Creates new keys
                                      keyList.add(key);
                                      return RepaintBoundary(
                                        key: key,
                                        child: replica(grid, false, true), // Borderless
                                      );
                                    },
                                  ),
                                )
                              )
                            ]
                          )
                          : Center(
                              child: Text(
                                "No Grids Selected",
                              ),
                            );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  } 
}