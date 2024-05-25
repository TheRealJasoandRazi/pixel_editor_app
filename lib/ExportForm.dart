import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'Cubit/GridListState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'CreateGrid.dart';
import 'ReplicaGrid.dart';

class ExportForm extends StatefulWidget {
  const ExportForm({super.key});

  @override
  State<ExportForm> createState() => _ExportFormState();
}

class _ExportFormState extends State<ExportForm> {
  Offset formPosition = Offset(0,0);
  double size = 0;

  void _handleFormUpdate(DragUpdateDetails details) {
    setState(() {
      formPosition += details.delta;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final gridListCubit = BlocProvider.of<GridListCubit>(context);

    if(size == 0){
      size = screenHeight * 0.25;
    }

    if(formPosition == Offset(0,0)){//initialise form location
      formPosition = Offset(screenWidth/2, screenWidth/2);
    }

    int stateLength = gridListCubit.state.length;

    return Stack( 
      children: [
        Positioned(
          left: formPosition.dx + size,
          top: formPosition.dy - 10,
          child: GestureDetector( //adjusts size of form
            onPanUpdate: (details) {
              setState(() { 
                size += details.delta.dx; 
                size = size.clamp(screenWidth * 0.25, screenWidth * 0.50); //add constraints
              }); 
            },
            child: Icon(
              Icons.arrow_outward
            ),
          )
        ),
        Positioned(
          left: formPosition.dx,
          top: formPosition.dy,
          child: GestureDetector(
            onPanUpdate: _handleFormUpdate,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.grey.shade300
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: size * 0.8,
                    width: size * 0.9,
                    child: stateLength > 0 //if theres grids available
                      ? ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                          child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(), // Disable scrolling
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3, // Number of columns
                              crossAxisSpacing: 10.0, // Spacing between columns
                              mainAxisSpacing: 10.0, // Spacing between rows
                            ),
                            itemCount: gridListCubit.state.length,
                            itemBuilder: (context, index) {
                              var grid = gridListCubit.state[index];
                              return ReplicaGrid(grid: grid);
                            },
                          ),
                        )
                      : Center(
                          child: Text(
                            "No Grids Available",
                          ),
                        ),
                  ),
                  SizedBox( // export button
                    width: size * 0.6, // Adjust width as needed
                    height: size * 0.2, // Adjust height as needed
                    child: GestureDetector(
                      onTap: () {
                        print("export button clicked");
                      },
                      child: Padding(
                        padding: EdgeInsets.all(10.0), // Adjust padding as needed
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(15.0), // Adjust border radius as needed
                          ),
                          child: Center(
                            child: Text("Export"),
                          )
                        ),
                      ),
                    ),
                  ),
                ],
              )
            )
          )
        )
      ]
    );
  } 
}