import 'package:flutter/material.dart';
import '../Grid.dart';

class BuildGrid extends StatelessWidget {
  final Layer pixelColors;
  final bool selected;
  final bool exporting;
  final double widthFactor;
  final double heightFactor;
  final bool includeOpacity;

  const BuildGrid({
    Key? key,
    required this.pixelColors,
    this.selected = false,
    this.exporting = false,
    this.widthFactor = 0.7,
    this.heightFactor = 0.6,
    this.includeOpacity = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> rows = [];

    for (int y = 0; y < pixelColors.layout.length; y++) {
      List<Widget> rowChildren = [];
      for (int x = 0; x < pixelColors.layout[y].length; x++) {
        rowChildren.add(
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: pixelColors.layout[y][x],
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
      child: Opacity(
        opacity: includeOpacity ? pixelColors.opacity : 1,
        child: Container(
          decoration: BoxDecoration(
            border: (selected && !exporting) ? Border.all(color: Colors.blue) : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: rows,
          ),
        ),
      )
    );
  }
}
