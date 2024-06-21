import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import '../../Cubit/GridListState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ResubleWidgets/BuildGrid.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/foundation.dart';

class ExportGifPage extends StatefulWidget {
  const ExportGifPage({Key? key}) : super(key: key);

  @override
  State<ExportGifPage> createState() => _ExportGifPageState();
}

class _ExportGifPageState extends State<ExportGifPage> {
  late final GridListCubit gridListCubit;
  List<GlobalKey> keyList = [];
  Uint8List? gifBytes;
  final ValueNotifier<bool> runGif = ValueNotifier<bool>(false);
  List<img.Image> images = [];
  bool capturedGrids = false;

  int delay = 80;
  int repeat = 0;

  @override
  void initState() {
    super.initState();
    gridListCubit = context.read<GridListCubit>();
  }

  void runAfterBuild() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      print(keyList);
      Future.delayed(Duration(milliseconds: 200), () { //fixes bug but also helps finish page transition
        if(!capturedGrids) {
          captureImages();
        }
        runGif.value = true;
        //runGif.value = true;
      });
    });
  }

  void captureImages() async{
    images.clear();
    // Load images from captured widgets
    for (int i = 0; i < keyList.length; i++) {
      Uint8List capturedImage = await captureWidget(keyList[i]);
      img.Image? image = img.decodeImage(capturedImage);
      if (image != null) {
        images.add(image);
      }
    }
    capturedGrids = true;
    print("done capturing images");
  }

  Future<Uint8List> _createGif() async { //i think this uses the UI thread
    final gif = img.GifEncoder();
    gif.repeat = repeat; // Loop indefinitely
    gif.delay = delay;

    for (img.Image image in images) {
      gif.addFrame(image); // 100 ms per frame
    }

    return Uint8List.fromList(gif.finish()!);
  }

  Future<Uint8List> captureWidget(GlobalKey globalKey) async {
    final RenderRepaintBoundary? boundary =
        globalKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

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

  Widget slider(String vari){
    return Padding(
      // Width scroll bar
      padding: const EdgeInsets.all(12.0),
      child: Container(
        //width: screenWidth * 0.5,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [ 
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.center,
                child: Text(
                  vari == "r" ? "Repeats" : "Delay"
                ),
              ),
            ),
            Expanded(
              flex: 17,
              child: Slider(
                value: vari == "r" ? repeat.toDouble() : delay.toDouble(),
                min: 0,
                max: vari == "r" ? 100 : 1000,
                onChanged: (newValue) {
                  setState(() {
                    vari == "r" ?
                      repeat = newValue.toInt()
                    :
                      delay = newValue.toInt();
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
                          onTap: (){
                            setState(() {
                              if (vari == "r") {
                                if (repeat > 0) {
                                  repeat = repeat - 1;
                                }
                              } else {
                                if (delay > 0) {
                                  delay = delay - 1;
                                }
                              }
                            });
                          },
                          child: Icon(Icons.minimize)
                        )
                      ),
                      Expanded( 
                        child: GestureDetector(
                          onTap: (){
                            setState(() {
                              if (vari == "r") {
                                if (repeat < 100) {
                                  repeat = repeat + 1;
                                }
                              } else {
                                if (delay < 1000) {
                                  delay = delay + 1;
                                }
                              }
                            });
                          },
                          child: Icon(Icons.plus_one)
                        )          
                      ),
                    ]
                  )
                )
              )
            )
          ],
        )
      )
    ); 
  }

  @override
  Widget build(BuildContext context) {
    print("building page");
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    runAfterBuild(); // Run GIF after rendering page

    return Scaffold(
      appBar: AppBar(
        title: Text('GIF Example'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Blue outlined images are included in the Gif"),
          Text("Click which grids you want to include/exclude from gif"),
          Expanded(
            child: Container(
              width: screenWidth * 0.9,
              height: screenHeight * 0.10,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: gridListCubit.state.length,
                itemBuilder: (context, index) {
                  final itemWidth = screenWidth / 12.0;
                  GlobalKey key = GlobalKey();
                  keyList.add(key); // Add key to the list
                  return RepaintBoundary(
                    key: key,
                    child: GestureDetector(
                      onTap: () {
                        print("test");
                      },
                      child: Row(
                        children: [
                          Container(
                            width: itemWidth,
                            child: BuildGrid(
                              grid: gridListCubit.state[index],
                              widthFactor: 0.9,
                              heightFactor: 0.9,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: ValueListenableBuilder<bool>( //ONLY BUILDS GIF WHEN VALUE CHANGES
              valueListenable: runGif,
              builder: (context, value, child) {
                if (value) {
                  print("building gif");
                  return Container(
                    width: screenWidth * 0.25,
                    height: screenHeight * 0.25,
                    child: FutureBuilder<Uint8List>(
                      future: _createGif(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          print('Error: ${snapshot.error}');
                          return Text('Error: ${snapshot.error}');
                        } else if (snapshot.hasData) {
                          return Image.memory(snapshot.data!);
                        } else {
                          return Text('No data yet...');
                        }
                      },
                    )
                  );
                } else {
                  return Container(
                  ); // Placeholder or empty container
                }
              },
            ),
          ),
          Expanded(
            child: slider(
              "r"
            )
          ),
          Expanded(
            child: slider(
              "d"
            )
          )
        ],
      ),
    );
  }
}
