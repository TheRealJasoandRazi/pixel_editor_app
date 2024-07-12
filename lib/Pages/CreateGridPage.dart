import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_editor_app/ResubleWidgets/CreateGrid.dart';
import 'package:pixel_editor_app/Cubit/GridListState.dart';
import 'package:pixel_editor_app/Cubit/SelectedGridState.dart';
import '../Cubit/GridSizeState.dart';
import '../Grid.dart';

class CreateGridPage extends StatefulWidget {
  const CreateGridPage({super.key});

  @override
  State<CreateGridPage> createState() => _CreateGridPageState();
}

class _CreateGridPageState extends State<CreateGridPage> {
  late double screenWidth;
  late double screenHeight;

  late GridSizeCubit gridSizeCubit;

  late double width;
  late double height;

  @override
  void initState() {
    super.initState();
    gridSizeCubit = context.read<GridSizeCubit>();
    height = gridSizeCubit.state['height']!.toDouble();
    width = gridSizeCubit.state['width']!.toDouble();
  }

  Widget buildGrid() {
    List<Widget> rows = [];
    final cellwidth = (screenWidth * 0.25) / width;
    final cellHeight = (screenHeight * 0.25) / height;

    for (int y = 0; y < height; y++) {
      List<Widget> rowChildren = [];
      for (int x = 0; x < width; x++) {
        rowChildren.add(
          Container(
            width: cellwidth,
            height: cellHeight,
            decoration: BoxDecoration(
              color: Colors.transparent,
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
    final gridListCubit = BlocProvider.of<GridListCubit>(context);
    final selectedGridCubit = BlocProvider.of<SelectedGridCubit>(context);

    final inputScreenWidth = MediaQuery.of(context).size.width;
    final inputScreenHeight = MediaQuery.of(context).size.height;

    screenHeight = inputScreenHeight;
    screenWidth = inputScreenWidth;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding( //width text
              padding: const EdgeInsets.all(12.0),
              child: Text("Width: ${width.toString()} px")
            ),
            Padding( //grid and height text
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded( //Filler to have the grid in the center
                    flex: 1,
                    child: Container()
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      alignment: Alignment.centerRight,
                        child: buildGrid()
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Height: ${height.toString()} px")
                    )
                  )
                ]
              ),
            ),
            Padding( //width scroll bar
              padding: const EdgeInsets.all(12.0),
                child: Container(
                width: screenWidth * 0.7,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [ 
                    Expanded(
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
                                  onTap: (){
                                    setState(() {
                                      if(width > 3){
                                        width = width - 1;
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
                                      if(width < 50){
                                        width = width + 1;
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
                ),
              ),
            ),
            Padding( //height scroll bar
              padding: const EdgeInsets.all(12.0),
                child: Container(
                width: screenWidth * 0.7,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(16.0)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [ 
                    Expanded(
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
                                  onTap: (){
                                    setState(() {
                                      if(height > 3){
                                        height = height - 1;
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
                                      if(height < 50){
                                        height = height + 1;
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
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  ElevatedButton( //Create Grid Button
                    onPressed: (){      
                      gridSizeCubit.changeValues(width.toInt(), height.toInt()); //remembers users last input  
                      gridListCubit.addGrid(
                        Grid(width.toInt(), height.toInt())
                      );
                      selectedGridCubit.changeSelection(gridListCubit.state.length - 1);
                      Navigator.pushNamed(context, '/EditorPage');
                    },
                    child: Text("Create Grid")
                  ),
                  SizedBox(height: 20.0), //adds spacing
                  ElevatedButton( //Cancel Button
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: Text("Cancel")
                  )
                ]
              )
            )
          ],
        ),
      ),
    );
  }
}