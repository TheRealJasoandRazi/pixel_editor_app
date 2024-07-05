import 'package:flutter/material.dart';
import '../../CreateGrid.dart';
import '../../Cubit/GridListState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_editor_app/Cubit/ExportSelectionState.dart';

import 'package:flutter/rendering.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:html' as html; //web only package
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../../ResubleWidgets/BuildGrid.dart';
import '../../Layers.dart';

class ExportImagePage extends StatefulWidget {
  const ExportImagePage({super.key});

  @override
  State<ExportImagePage> createState() => _ExportImagePageState();
}

class _ExportImagePageState extends State<ExportImagePage> {

  late final ExportSelectionCubit exportSelectionCubit;
  List<GlobalKey> keyList = [];
  List<Layers> exportList = [];

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

  void saveImageWeb(Uint8List capturedImage) { //for web only
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

  @override
  Widget build(BuildContext context) {
    final gridListCubit = BlocProvider.of<GridListCubit>(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              height: screenHeight * 0.4,
              width: screenWidth * 0.9,
              child: gridListCubit.state.length > 0
                  ? ScrollConfiguration( //shows options
                      behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                      child: GridView.builder(
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
                              setState(() {
                                if (exportList.contains(grid)) {
                                  exportList.remove(grid);
                                } else {
                                  exportList.add(grid);
                                }
                                keyList.clear();//prevents unselected grids from being exported
                              });
                            },
                            child: Stack(
                              children: grid.displayInStack(exportList.contains(grid), false)
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
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container( // Second container that will show borderless grid
              width: screenWidth * 0.9,
              height: screenHeight * 0.4,
              child: exportList.isNotEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("Previews")
                      ),
                      Expanded(
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                          child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 10.0,
                              mainAxisSpacing: 10.0,
                            ),
                            itemCount: exportList.length,
                            itemBuilder: (context, index) {
                              var grid = exportList[index];
                              GlobalKey key = GlobalKey(); // Creates new keys
                              keyList.add(key);
                              return RepaintBoundary(
                                key: key,
                                child: Stack(
                                  children: grid.displayInStack(false, true)
                                )
                              );
                            },
                          ),
                        )
                      ), 
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                _saveSelectedWidgets(keyList);
                                Navigator.pop(context);
                              },
                              child: Text("Export"),
                            ),
                            SizedBox(width: 10), // Add space between buttons if needed
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Cancel"),
                            ),
                          ],
                        ),
                      ),
                    ]
                  )
                : Column( //IF EXPORT LIST IS EMPTY
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "No Grids Selected",
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Cancel"),
                      ),
                    ],
                  ),
            ),
          )
        ]
      )
    );
  }
}