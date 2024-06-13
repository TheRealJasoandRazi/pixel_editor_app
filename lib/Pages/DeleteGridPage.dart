import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../CreateGrid.dart';
import '../Cubit/GridListState.dart';

class DeleteGridPage extends StatefulWidget {
  const DeleteGridPage({super.key});

  @override
  State<DeleteGridPage> createState() => _DeleteGridPageState();
}

class _DeleteGridPageState extends State<DeleteGridPage> {
  late final GridListCubit gridListCubit;
  final Set<int> selectedGrids = {}; // Track selected grids by their index

  @override
  void initState() {
    super.initState();
    gridListCubit = context.read<GridListCubit>();
  }

  Widget replica(CreateGrid grid, bool selected) {
    List<Widget> rows = [];

    for (int y = 0; y < grid.height; y++) {
      List<Widget> rowChildren = [];
      for (int x = 0; x < grid.width; x++) {
        rowChildren.add(
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: grid.pixelColors[y][x],
                border: Border.all(color: Colors.grey.shade400),
              ),
            ),
          ),
        );
      }
      rows.add(Expanded(
        child: Row(
          children: rowChildren,
        ),
      ));
    }

    return Container(
      decoration: BoxDecoration(
        border: selected ? Border.all(color: Colors.blue, width: 2) : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: rows,
      ),
    );
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
                  selectedGrids.toList().reversed.forEach((index) {
                    gridListCubit.removeGridAtIndex(index);
                  });
                  selectedGrids.clear();
                });
                Navigator.of(context).pop();
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
          child: BlocBuilder<GridListCubit, List<CreateGrid>>(
            builder: (context, gridList) {
              if (gridList.isEmpty) {
                return Center(
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
                          onPressed: (){
                            Navigator.pop(context);
                          }, 
                          child: Text("Cancel")
                        )
                      )
                    ]
                  )
                );
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      "Tap to select grids",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Expanded( //grid display
                    child: ListView.builder(
                      itemCount: gridList.length,
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
                                      child: replica(gridListCubit.state[index], selectedGrids.contains(index))
                                    )
                                  )
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Text("Dimensions: ${gridListCubit.state[index].width} x ${gridListCubit.state[index].height}")   
                                  )        
                                )
                              ]
                            )
                          )
                        );
                      },
                    ),
                  ),
                  Center(
                    child: Row(
                      children: [
                        Padding( //Delete Button
                          padding: const EdgeInsets.only(right: 12.0),
                          child: GestureDetector(
                            onTap: () {
                              if(!selectedGrids.isEmpty){
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
                ]
              );
            },
          ),
        ),
      )
    );
  }
}
