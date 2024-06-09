import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'package:pixel_editor_app/CreateGrid.dart';
import 'package:pixel_editor_app/Cubit/GridListState.dart';
import 'package:pixel_editor_app/Cubit/PixelateState.dart';
import 'package:pixel_editor_app/ImageWrapper.dart';
import 'Cubit/ImageListState.dart';

import 'package:image/image.dart' as img;
import 'package:flutter/foundation.dart';


class PixelateForm extends StatefulWidget {

  @override
  State<PixelateForm> createState() => _PixelateFormState();
}

class _PixelateFormState extends State<PixelateForm> {
  Offset formPosition = Offset(0,0);

  void _handleFormUpdate(DragUpdateDetails details) {
    setState(() {
      formPosition += details.delta;
    });
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
        print('Image width: ${image.width}');
        print('Image height: ${image.height}');
        print(image.length);
        print('Number of channels: ${image.channels}');
        
        return [image.width, image.height];
      }
      return [];
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  List<Uint8List> selectedImages = []; //hold selected images

  @override
  Widget build(BuildContext context) {
    final pixelateCubit = BlocProvider.of<PixelateCubit>(context); //retieve form state
    final imageListCubit = BlocProvider.of<ImageListCubit>(context);
    
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if(formPosition == Offset(0,0)){//initialise form location
      formPosition = Offset(screenWidth * 0.25, screenWidth * 0.25);
    }

    double size = screenHeight * 0.25;
    final height = screenHeight * 0.25;

    final gridListCubit = BlocProvider.of<GridListCubit>(context);

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
                      if (imageListCubit.state.length > 0)
                        SizedBox(
                          height: size * 0.1,
                          width: size * 0.9,
                          child: Center(
                            child: Text(
                              'Click on images to select',
                            )
                          )
                        ),
                      SizedBox(
                        height: size * 0.8,
                        width: size * 0.9,
                        child: imageListCubit.state.length > 0
                            ? ScrollConfiguration( //shows options
                                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                                child: GridView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 10.0,
                                    mainAxisSpacing: 10.0,
                                  ),
                                  itemCount: imageListCubit.state.length,
                                  itemBuilder: (context, index) {
                                    var image = imageListCubit.state[index];
                                    return GestureDetector(
                                      onTap: () {
                                        setState((){
                                          if(selectedImages.contains(image.image)){
                                            selectedImages.remove(image.image);
                                          } else {
                                            selectedImages.add(image.image);
                                          }
                                          //image.selected = !image.selected; //modifies image in cubit
                                        });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          border: selectedImages.contains(image.image) ? Border.all(color: Colors.blue, width: 2.0) : Border.all(color: Colors.transparent),
                                        ),
                                        child: Image.memory(
                                          image.image, 
                                          fit: BoxFit.fill,
                                        )                                 
                                      )
                                    );
                                  },
                                ),
                              )
                            : Center(
                                child: Text(
                                  "No Images Available",
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: size * 0.8,
                        height: size * 0.2,
                        child: Center(
                          child: Text(
                            "Input your desired size"
                          )
                        )
                      ),
                      SizedBox(
                        width: size * 0.8,
                        height: size * 0.3,
                        child: TextField(
                          controller: _widthController,
                          keyboardType: TextInputType.number, // Set input type to number
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly // Allow only digits
                          ],
                          decoration: InputDecoration(
                            hintText: 'Width',
                            border: InputBorder.none,
                          ),
                        )
                      ),
                      SizedBox(
                        width: size * 0.8,
                        height: size * 0.3,
                        child: TextField(
                          keyboardType: TextInputType.number, // Set input type to number
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly // Allow only digits
                          ],
                          controller: _heightController,
                          decoration: InputDecoration(
                            hintText: 'height',
                            border: InputBorder.none,
                          ),
                        )
                      ),
                      SizedBox( //move to other side
                        width: size * 0.6,
                        height: size * 0.2,
                        child: GestureDetector(
                          onTap: () async {
                            final String widthInput = _widthController.text;
                            final String heightInput = _heightController.text;

                            int? width = int.tryParse(widthInput);
                            int? height = int.tryParse(heightInput);

                            // Check if the conversions were successful
                            if (width != null && height != null) {
                              for(Uint8List image in selectedImages){
                                List<int> dimensions = await checkImageHeader(image);
                                Map<String, dynamic> params = {
                                  'image': image,
                                  'newWidth': width,
                                  'newHeight': height,
                                  'oldWidth': dimensions[0],
                                  'oldHeight': dimensions[1]
                                };
                                List<List<Color>> newimage = await compute(nearestNeighborInterpolation, params); //doesn't improve performance
                                
                                gridListCubit.addGrid(CreateGrid(width: newimage[0].length, height: newimage.length, pixelColors: newimage));   
                              }
                            } else {
                              print("aint work");
                            }
                            pixelateCubit.changePixelateFormVisibility();
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(15.0),
                              ),
                              child: Center(
                                child: Text("Pixelate"),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]
                  )
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}