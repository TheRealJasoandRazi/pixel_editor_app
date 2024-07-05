import 'package:flutter/material.dart';
import 'package:pixel_editor_app/ResubleWidgets/BuildGrid.dart';
import '../Layers.dart';

class LayeringPage extends StatefulWidget {
  final Layers initialListOfLayers;

  const LayeringPage({
    super.key,
    required this.initialListOfLayers,
  });

  @override
  State<LayeringPage> createState() => _LayeringPageState();
}

class _LayeringPageState extends State<LayeringPage> {
  @override
  void initState() {
    super.initState();
  }

  Widget layer(int index) {
    List<List<Color>> layer = widget.initialListOfLayers.allLayers[index];
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              setState(() {
                widget.initialListOfLayers.changeEditable(layer);
              });
            },
            child: FractionallySizedBox(
              widthFactor: 0.8,
              heightFactor: 0.4,
              child: Opacity(
                opacity: widget.initialListOfLayers.isEditable(layer) ? 1.0 : 0.5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.edit
                    )
                  )
                )
              )
            )
          ),
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              setState(() {
                if (widget.initialListOfLayers.isViewable(layer)) {
                  widget.initialListOfLayers.removeView(layer);
                } else {
                  widget.initialListOfLayers.addView(layer);
                }
              });
            },
            child: FractionallySizedBox(
              widthFactor: 0.8,
              heightFactor: 0.4,
              child: Opacity(
                opacity: widget.initialListOfLayers.isViewable(layer) ? 1.0 : 0.5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.remove_red_eye
                    )
                  )
                )
              )
            )
          ),
        ),
        Expanded(
          flex: 4,
          child: BuildGrid(
            pixelColors: layer,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.initialListOfLayers.allLayers.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: screenWidth * 0.9,
                    height: screenHeight * 0.30,
                   child: layer(index)
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    widget.initialListOfLayers.addLayer();
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Row(
                      children:[
                        Icon(
                          Icons.layers
                        ),
                        Icon(
                          Icons.add
                        )
                      ]
                    )
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  print("show delete button");
                },
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.layers),
                        Text( //need to find an icon for this
                          "-",
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/EditorPage");
                },
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Edit Page"),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
