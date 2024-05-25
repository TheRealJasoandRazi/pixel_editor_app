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
  List<bool> selectedGridsList = [];

  Widget replicateGrid(CreateGrid grid){
    bool selected = false; //tracks if grid is clicked on

    return GridView.builder( //rebuild existing grids///////////////////////////////
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: grid.width, // Number of columns
      ),
      itemCount: grid.width * grid.height,
      itemBuilder: (context, index) {
        int rowIndex = index ~/ grid.width;
        int columnIndex = index % grid.width;

        Color color = grid.pixelColors[rowIndex][columnIndex];

        return GestureDetector(
          onTap: (){
            selected = !selected;
          },
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: selected ? Colors.blueAccent : Colors.grey.shade400),
              color: color,
            ),
          )
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    //final screenHeight = MediaQuery.of(context).size.height;

    final gridListCubit = BlocProvider.of<GridListCubit>(context);
    final size = screenWidth * 0.25;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.grey.shade300
      ),
      child: Column(
        children: [
          SizedBox( //list of selected grids, //add blocBuilder for gridlist
            height: size * 0.8,
            width: size * 0.9,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Number of columns
                crossAxisSpacing: 10.0, // Spacing between columns
                mainAxisSpacing: 10.0, // Spacing between rows
              ),
              itemCount: gridListCubit.state.length,
              itemBuilder: (context, index) {
                var grid = gridListCubit.state[index];
                //return replicateGrid(grid);
                return ReplicaGrid(grid: grid);
              }
            ), 
          ),
          SizedBox( //export button
            width: size * 0.6, // Adjust width as needed
            height: size * 0.2, // Adjust height as needed
            child: GestureDetector(
              onTap: () {
                print("export button clicked");
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                ),
              ),
            ),
          ),
        ],
      )
    );
  }
}