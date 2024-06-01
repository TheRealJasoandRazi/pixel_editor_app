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
      // Find the nearest pixel in the input image
      final int xIn = (xOut * scaleX).floor();
      final int yIn = (yOut * scaleY).floor();
      //final int inputIndex = (yIn * width + xIn); //something wrong here

      // Extract RGB components from input pixel data using img.Image object
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

  @override
  Widget build(BuildContext context) {
    final pixelateCubit = BlocProvider.of<PixelateCubit>(context); //retieve form state
    final imageListCubit = BlocProvider.of<ImageListCubit>(context);

    //grabs values entered into the form
    final TextEditingController _widthController = TextEditingController();
    final TextEditingController _heightController = TextEditingController();
    
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if(formPosition == Offset(0,0)){//initialise form location
      formPosition = Offset(screenWidth/2, screenWidth/2);
    }

    final height = screenHeight * 0.25;

    final gridListCubit = BlocProvider.of<GridListCubit>(context);

    return Positioned(
      left: formPosition.dx,
      top: formPosition.dy,
      child: GestureDetector(
        onPanUpdate: _handleFormUpdate,
        child: Container(
          width: height,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.0),
            color: Colors.grey.shade400,
          ),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Text(
                    'Pixelate Form',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: SizedBox(
                    width: height * 0.8,
                    child: TextField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      controller: _widthController,
                      decoration: InputDecoration(
                        labelText: 'Width',
                        fillColor: Colors.grey.shade400,
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
                    width: height * 0.8,
                    child: TextField(
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      keyboardType: TextInputType.number,
                      controller: _heightController,
                      decoration: InputDecoration(
                        labelText: 'Height',
                        fillColor: Colors.grey.shade400,
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
                  child: Container(
                    width: 100, // Adjust the width as needed
                    height: 50, // Adjust the height as needed
                    decoration: BoxDecoration(
                        color: Colors.grey.shade500, // Background color
                        borderRadius: BorderRadius.circular(8.0), // Rounded corners
                        boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: Offset(0, 3), // Shadow position
                            ),
                        ],
                    ),
                    child: GestureDetector(
                      onTap: () async {
                      final String widthInput = _widthController.text;
                      final String heightInput = _heightController.text;

                      int? width = int.tryParse(widthInput);
                      int? height = int.tryParse(heightInput);

                      // Check if the conversions were successful
                      if (width != null && height != null) {
                        for(ImageWrapper image in imageListCubit.state){
                          if(image.selected){
                            List<int> dimensions = await checkImageHeader(image.image);
                            Map<String, dynamic> params = {
                              'image': image.image,
                              'newWidth': width,
                              'newHeight': height,
                              'oldWidth': dimensions[0],
                              'oldHeight': dimensions[1]
                            };
                            List<List<Color>> newimage = await compute(nearestNeighborInterpolation, params); //doesn't improve performance
                            gridListCubit.addGrid(CreateGrid(width: newimage.length, height: newimage[0].length, pixelColors: newimage));    
                            image.selected = !image.selected;
                          }
                        }
                      } else {
                        print("aint work");
                      }
                      pixelateCubit.changePixelateFormVisibility();
                      },
                      child: Center(
                          // Center the text within the container
                          child: Text(
                              'Submit',
                              style: TextStyle(color: Colors.white),
                          ),
                      ),
                    )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  
  }
}