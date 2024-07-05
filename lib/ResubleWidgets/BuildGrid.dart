import 'package:flutter/material.dart';

class BuildGrid extends StatelessWidget {
  final List<List<Color>?>? pixelColors;
  final bool selected;
  final bool exporting;
  final double widthFactor;
  final double heightFactor;

  const BuildGrid({
    Key? key,
    required this.pixelColors,
    this.selected = false,
    this.exporting = false,
    this.widthFactor = 0.7,
    this.heightFactor = 0.6,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];

    for (int y = 0; y < pixelColors!.length; y++) {
      List<Widget> rowChildren = [];
      for (int x = 0; x < pixelColors![y]!.length; x++) {
        rowChildren.add(
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: pixelColors![y]![x],
                border: exporting ? null : Border.all(color: Colors.grey.shade400),
              ),
            ),
          ),
        );
      }
      rows.add(
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: rowChildren,
          ),
        ),
      );
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
        ),
      ),
    );
  }
}
