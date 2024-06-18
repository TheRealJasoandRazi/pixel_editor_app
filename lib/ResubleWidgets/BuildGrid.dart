import 'package:flutter/material.dart';
import 'package:pixel_editor_app/CreateGrid.dart';

class BuildGrid extends StatelessWidget {
  final CreateGrid grid;
  final bool selected;
  final bool exporting;
  final double widthFactor;
  final double heightFactor;

   const BuildGrid({
    super.key,
    required this.grid,
    this.selected = false,
    this.exporting = false,
    this.widthFactor = 0.7,
    this.heightFactor = 0.6
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];

    for (int y = 0; y < grid.height; y++) {
      List<Widget> rowChildren = [];
      for (int x = 0; x < grid.width; x++) {
        rowChildren.add(
          Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: grid.pixelColors.pixelColors[y][x],
              border: exporting ? null : Border.all(color: Colors.grey.shade400)
            ),   
          )
          )
        );
      }
      rows.add(Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: rowChildren,
        )
      ));
    }

    return FractionallySizedBox(
      widthFactor: widthFactor,
      heightFactor: heightFactor,
      child: Container(
        decoration: BoxDecoration(
          border: (selected && !exporting) ? Border.all(color: Colors.blue) : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: rows,
        )
      )
    );
  }
}