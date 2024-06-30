import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_editor_app/Cubit/SelectedGridState.dart';
import 'package:pixel_editor_app/Pages/EditorPage.dart';
import 'package:pixel_editor_app/ResubleWidgets/BuildGrid.dart';
import '../CreateGrid.dart';
import '../Cubit/GridListState.dart'; // Ensure this import is correct

class DeleteGridPage extends StatefulWidget {
  const DeleteGridPage({super.key});

  @override
  State<DeleteGridPage> createState() => _DeleteGridPageState();
}

class _DeleteGridPageState extends State<DeleteGridPage> {
  late final GridListCubit gridListCubit;
  late final SelectedGridCubit selectedGridCubit;
  final Set<int> selectedGrids = {}; // Track selected grids by their index

  @override
  void initState() {
    super.initState();
    selectedGridCubit = context.read<SelectedGridCubit>();
    gridListCubit = context.read<GridListCubit>();
  }

  @override
  void dispose(){
    super.dispose();
  }

  void _confirmDeletion() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Deletion"),
          content: Text("Are you sure you want to delete the selected grids?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Confirm"),
              onPressed: () {
                setState(() {
                  selectedGrids.forEach((index) {
                    try{
                      if(gridListCubit.state[index] == selectedGridCubit.state){
                        selectedGridCubit.changeSelection(null);
                      }
                      gridListCubit.removeGridAtIndex(index);
                    } catch(e){
                      print(e);
                      print("error deleting grid");
                    }
                  });
                  selectedGrids.clear();
                });
                Navigator.pop(context);
                //Navigator.pushNamed(context, "/DeleteGridPage");
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: SizedBox(
          height: screenHeight * 0.9,
          width: screenWidth * 0.9,
          child: 
              gridListCubit.state.isEmpty ?
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: Text("No grids available."),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4),
                        child: ElevatedButton(
                          onPressed: () {
                            selectedGrids.clear();
                            Navigator.pop(context); //????
                            //Navigator.pushNamed(context, "/EditorPage");
                          },
                          child: Text("Cancel"),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Text(
                        "Tap to select grids",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: gridListCubit.state.length,
                        itemBuilder: (context, index) {
                          bool isSelected = selectedGrids.contains(index);
                          return Padding(
                            padding: const EdgeInsets.all(8),
                            child: Container(
                              width: screenWidth * 0.8,
                              height: screenWidth * 0.3,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            if (isSelected) {
                                              selectedGrids.remove(index);
                                            } else {
                                              selectedGrids.add(index);
                                            }
                                          });
                                        },
                                        child: Builder(
                                          builder: (context) {
                                            try {
                                              return BuildGrid(grid: gridListCubit.state[index],  selected: isSelected, widthFactor: 0.9, heightFactor: 0.9);
                                            } catch (e) {
                                              print(e);
                                              print(gridListCubit.state.length);
                                              print("Issue with displaying grid");
                                              print("index is ${index}");
                                              print("length is ${gridListCubit.state.length}");
                                              return Container(
                                                child: Text("Error: Grid display issue"),
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Center(
                                      child: Text(
                                        "Dimensions: ${gridListCubit.state[index].width} x ${gridListCubit.state[index].height}",
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding( //DELETE BUTTON
                            padding: const EdgeInsets.only(right: 12.0),
                            child: GestureDetector(
                              onTap: () {
                                if (selectedGrids.isNotEmpty) {
                                  _confirmDeletion();
                                }
                              },
                              child: Container(
                                width: screenWidth * 0.20,
                                height: screenHeight * 0.04,
                                decoration: BoxDecoration(
                                  color: selectedGrids.isEmpty ? Colors.grey : Colors.blue,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Center(
                                  child: Text(
                                    "Delete",
                                    style: TextStyle(
                                      color: selectedGrids.isEmpty ? Colors.black54 : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding( //CANCEL BUTTON
                            padding: const EdgeInsets.only(left: 12.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push( //DO TRANSITION BACK, SINCE POP DOESN'T AUTOMATICALLY REFRESH
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder: (context, animation, secondaryAnimation) {
                                      return EditorPage();
                                    },
                                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                      return FadeTransition(
                                        opacity: Tween<double>(
                                          begin: 0.0,
                                          end: 1.0,
                                        ).animate(animation),
                                        child: child,
                                      );
                                    },
                                  ),
                                );
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
                                    "Cancel",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              )
            )
          );
  }
}
