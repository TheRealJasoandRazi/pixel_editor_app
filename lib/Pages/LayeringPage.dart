import 'package:flutter/material.dart';
import 'package:pixel_editor_app/Cubit/GridListState.dart';
import 'package:pixel_editor_app/ResubleWidgets/BuildGrid.dart';
import '../Grid.dart';
import '../ResubleWidgets/SnackBarMessage.dart';
import '../Cubit/DeleteButtonState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../ResubleWidgets/DisplayLayerSettings.dart';

class LayeringPage extends StatefulWidget {
  //final Grid grid;
  final int gridIndex;
  const LayeringPage({
    super.key,
    required this.gridIndex,
  });

  @override
  State<LayeringPage> createState() => _LayeringPageState();
}

class _LayeringPageState extends State<LayeringPage> {
  late final DeleteButtonCubit deleteButtonCubit;
  late final GridListCubit gridListCubit;

  @override
  void initState() {
    super.initState();
    deleteButtonCubit = context.read<DeleteButtonCubit>(); 
    gridListCubit = context.read<GridListCubit>();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: ListenableBuilder(
          listenable: gridListCubit.state[widget.gridIndex], //Rebuild page when something gets deleted
          builder: (context, child) {
            Grid grid = gridListCubit.state[widget.gridIndex]; //always get the most up to date grid
            return Column( //unnecessaey?
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: grid.allLayers.length,
                    itemBuilder: (context, index) {
                      return SizedBox(
                        width: screenWidth * 0.9,
                        height: screenHeight * 0.30,
                        child: Container( //for layout purposes
                          decoration: BoxDecoration(
                            border: Border.all(
                              //color: Colors.pink
                            )
                          ),
                        child: DisplayLayerSettings(
                          grid: grid,
                          layerIndex: index,
                        ),
                        )
                      );
                    },
                  ),       
                ),
              ],
            );
          }
        )
      ),
      bottomNavigationBar: BottomAppBar( //BOTTOM BAR
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    gridListCubit.state[widget.gridIndex].addLayer();
                    //grid.addLayer();
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
            Expanded( //OPEN DELETE BUTTON
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  setState(() { //refresh page
                    deleteButtonCubit.changeState();
                  });
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
                            fontSize: 20.0,
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
                  if(deleteButtonCubit.state){
                    deleteButtonCubit.changeState();
                  }
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
