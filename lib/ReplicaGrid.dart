import 'package:flutter/material.dart';
import 'package:pixel_editor_app/CreateGrid.dart';


//this creates a replica for existing grids, donne to avoid rendering alot of uneccessary widgets and for the selected state management
class ReplicaGrid extends StatefulWidget {
  final CreateGrid grid; 

  const ReplicaGrid({
    required this.grid,
    Key? key,
  }) : super(key: key);

  @override
  _ReplicaGridState createState() => _ReplicaGridState();
}

class _ReplicaGridState extends State<ReplicaGrid> {
  bool selected = false;

  void changeSelection() {
    setState(() {
      selected = !selected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: changeSelection,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: selected ? Colors.blueAccent : Colors.grey.shade400,
            width: 2.0, // Width of the border
          ),
        ),
        child: ScrollConfiguration( //ensures there are no scrollbars in the gridview
          behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(), // Disable scrolling
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: widget.grid.width, // Number of columns
            ),
            itemCount: widget.grid.width * widget.grid.height,
            itemBuilder: (context, index) {
              int rowIndex = index ~/ widget.grid.width;
              int columnIndex = index % widget.grid.width;

              Color color = widget.grid.pixelColors[rowIndex][columnIndex];

              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  color: color,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
