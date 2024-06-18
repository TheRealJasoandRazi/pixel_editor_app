import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../CreateGrid.dart';
import '../Cubit/GridListState.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';


class ImportPage extends StatefulWidget {
  final String previousPage;

  const ImportPage({Key? key, required this.previousPage}) : super(key: key);

  @override
  State<ImportPage> createState() => _ImportPageState();
}


class _ImportPageState extends State<ImportPage> {
  late double imageWidth;
  late double imageHeight;
  late Uint8List? currentImage;
  bool opened = false;

  double width = 3;
  double height = 3;

  late final GridListCubit gridListCubit;

  List<List<Color>>? newimage;

   @override
  void initState() {
    super.initState();
    gridListCubit = context.read<GridListCubit>();
  }

  void getNewImage() async {
    final oldImage = currentImage;
    final potentialImage = await _selectFile();
    if(potentialImage != null){
      if(oldImage != potentialImage){
        setState( () {
          currentImage = potentialImage; //set new image
          newimage = null; //reset pixel grid if there is one
        });
      }
    }
  }

  Future<Uint8List?> _selectFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpeg'], // Allow only PNG and Jpeg files
    );
    if (result != null && result.files.isNotEmpty) {
      final image = result.files.first.bytes;
      ui.Codec codec = await ui.instantiateImageCodec(image!);
      ui.FrameInfo frameInfo = await codec.getNextFrame();
      imageWidth = frameInfo.image.width.toDouble();
      imageHeight = frameInfo.image.height.toDouble();
      return image;
    }
    return null;
  }

  Widget sliders(double screenHeight, double screenWidth){
    return Column(
      children: [
        Padding(
          // Height scroll bar
          padding: const EdgeInsets.all(12.0),
          child: Container(
            width: screenWidth * 0.5,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  // HEIGHT
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text("H"),
                  ),
                ),
                Expanded(
                  flex: 17,
                  child: Slider(
                    value: height.round().toDouble(),
                    min: 3,
                    max: 50,
                    onChanged: (newValue) {
                      setState(() {
                        height = newValue.round().toDouble();
                      });
                    },
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade400,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (height > 3) {
                                    height = height - 1;
                                  }
                                });
                              },
                              child: Icon(Icons.minimize),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (height < 50) {
                                    height = height + 1;
                                  }
                                });
                              },
                              child: Icon(Icons.plus_one),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          // Width scroll bar
          padding: const EdgeInsets.all(12.0),
          child: Container(
            width: screenWidth * 0.5,
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  // WIDTH
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text("W"),
                  ),
                ),
                Expanded(
                  flex: 17,
                  child: Slider(
                    value: width.round().toDouble(),
                    min: 3,
                    max: 50,
                    onChanged: (newValue) {
                      setState(() {
                        width = newValue.round().toDouble();
                      });
                    },
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.shade400,
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (width > 3) {
                                    width = width - 1;
                                  }
                                });
                              },
                              child: Icon(Icons.minimize),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (width < 50) {
                                    width = width + 1;
                                  }
                                });
                              },
                              child: Icon(Icons.plus_one),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget page(double screenHeight, double screenWidth){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        GestureDetector( //button
          onTap: (){
            getNewImage();
          },
          child: Container(
            width: screenWidth * 0.25,
            height: screenHeight * 0.05,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text("Choose another Image")
            )
          )
        ),
        Container( //Image
          width: screenWidth * 0.5,
          height: screenHeight * 0.3,
          child: Stack(
            children: [
              Opacity(
                opacity: 0.5, // Set the opacity value here
                child: Image.memory(
                  currentImage!,
                  width: screenWidth * 0.5,
                  height: screenHeight * 0.3,
                  fit: BoxFit.fill
                ),
              ),
              newimage == null
                ? buildGrid(screenWidth, screenHeight)
                : buildGrid(screenWidth, screenHeight, cellColors: newimage),
            ]
          )
        ),
        newimage == null
      ? sliders(screenHeight, screenWidth)
      : Center(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                newimage = null;
              });
            },
            child: Text("Reset"),
          ),
        ),
        newimage == null
          ? GestureDetector(
              onTap: () async {
                List<int> dimensions = await checkImageHeader(currentImage);
                Map<String, dynamic> params = {
                  'image': currentImage,
                  'newWidth': width,
                  'newHeight': height,
                  'oldWidth': dimensions[0],
                  'oldHeight': dimensions[1]
                }; 
                List<List<Color>>? pixelimage = await compute(nearestNeighborInterpolation, params); //doesn't improve performance
                setState(() {
                  newimage = pixelimage;
                });
              },
              child: Container(
                width: screenWidth * 0.25,
                height: screenHeight * 0.05,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text("Pixelate Image")
                )
              )
            )
          : Container(),
          Center(
            child: Row( //OK
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                newimage != null ? Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: GestureDetector(
                    onTap: () {
                      gridListCubit.addGrid(CreateGrid(width: newimage![0].length, height: newimage!.length, pixelColors: newimage)); 
                      if(widget.previousPage == "/EditorPage"){
                        Navigator.pop(context);
                      } else {
                        Navigator.pushNamed(context, '/EditorPage');
                      }
                    },
                    child: Container(
                      width: screenWidth * 0.20,
                      height: screenHeight * 0.04,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(
                          "Ok"
                        )
                      ),
                    ),
                  ),
                ) : Container(),
                Padding( //Cancel Button
                  padding: const EdgeInsets.only(left: 12.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      width: screenWidth * 0.20,
                      height: screenHeight * 0.04,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text(
                          "Cancel"
                        ),
                      )
                    ),
                  )
                )
              ],
            )
          )
      ],
    );
  }

  Future<List<List<Color>>> nearestNeighborInterpolation(Map<String, dynamic> params) async {
  Uint8List inputimage = params['image'];
  int newWidth = params['newWidth'];
  int newHeight = params['newHeight'];
  int oldWidth = params['oldWidth'];
  int oldHeight = params['oldHeight'];

  img.Image? image = img.decodeImage(inputimage);
  // Calculate scaling factors
  final double scaleX = oldWidth / newWidth;
  final double scaleY = oldHeight / newHeight;

  // Create a buffer for the output image pixels
  final List<List<Color>> pixelColors = List.generate(newHeight, (y) => List.generate(newWidth, (x) => Colors.transparent));

  // Map the pixel data to the new image size
  for (int yOut = 0; yOut < newHeight; yOut++) {
    for (int xOut = 0; xOut < newWidth; xOut++) {
      // Find the nearest pixel in the old image
      final int xIn = (xOut * scaleX).floor();
      final int yIn = (yOut * scaleY).floor();

      // Extract RGB components from old image pixel
      final pixel = image!.getPixel(xIn, yIn);
      final int r = img.getRed(pixel);
      final int g = img.getGreen(pixel);
      final int b = img.getBlue(pixel);
      final int a = img.getAlpha(pixel);

      // Store color in the output list
      pixelColors[yOut][xOut] = Color.fromRGBO(r, g, b, a / 255);
    }
  }

  return pixelColors;
  }


  Future<List<int>> checkImageHeader(Uint8List? imageData) async {
    try {
      if (imageData != null) {
        img.Image? image = img.decodeImage(imageData);
        if (image == null) {
          print('Failed to decode image.');
          return [];
        }

        // Print image information
        /*print('Image width: ${image.width}');
        print('Image height: ${image.height}');
        print(image.length);
        print('Number of channels: ${image.channels}');*/
        
        return [image.width, image.height];
      }
      return [];
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  Widget buildGrid(double screenWidth, double screenHeight, {List<List<Color>>? cellColors}) { //copy and pasted function
    List<Widget> rows = [];
    final cellwidth = (screenWidth * 0.5) / width;
    final cellHeight = (screenHeight * 0.3) / height;

    for (int y = 0; y < height; y++) {
      List<Widget> rowChildren = [];
      for (int x = 0; x < width; x++) {
        final cellColor = cellColors != null ? cellColors[y][x] : Colors.transparent;

        rowChildren.add(
          Container(
            width: cellwidth,
            height: cellHeight,
            decoration: BoxDecoration(
              color: cellColor,
              border: Border.all(color: Colors.grey.shade400)
            ),   
          )
        );
      }
      rows.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rowChildren,
      ));
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: rows,
    );
  }

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: 
      opened == false ? FutureBuilder<Uint8List?>(
        future: _selectFile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if(snapshot.data == null){
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("Import cancelled, Click to return"),
              ),
            );
          } else {
            opened = true;
            currentImage = snapshot.data!;
            return page(screenHeight, screenWidth);    
          }
        },
      ) : page(screenHeight, screenWidth)
    );
  }
}