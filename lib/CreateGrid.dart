import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_editor_app/Cubit/EraseState.dart';
import 'package:pixel_editor_app/Cubit/GridListState.dart';
import 'Cubit/PaintState.dart';
import 'Cubit/ColorState.dart';

class PixelColors with ChangeNotifier { //change Notifier triggered here
  late List<List<Color>> _pixelColors;

  // Constructor to initialize with a width and height
  PixelColors(int width, int height) {
    _pixelColors = List.generate(height, (_) => List.filled(width, Colors.transparent));
  }

  PixelColors.input(List<List<Color>?>? pixelColors) {
    if (pixelColors != null) {
      final height = pixelColors.length;
      final width = pixelColors[0]!.length; // Use non-null assertion operator (!) since pixelColors[0] is already checked

      _pixelColors = List.generate(height, (row) {
        return List<Color>.generate(width, (col) {
          return pixelColors[row]![col]; // Safe to access directly with ! as we ensured pixelColors[row] is not null;
        });
      });
    }
  }
  
  // Getter to access the pixelColors grid
  List<List<Color>> get pixelColors => _pixelColors;

  // Method to paint a specific color at a given row and column
  void paint(int row, int column, Color color) {
    if (row >= 0 && row < _pixelColors.length && column >= 0 && column < _pixelColors[row].length) {
      _pixelColors[row][column] = color;
      notifyListeners();
    }
  }
}

class CreateGrid extends StatefulWidget {
  final int width;
  final int height;
  final PixelColors pixelColors; // Declare PixelColors instance as a member variable
  final Key? key;

  CreateGrid({
    required this.width,
    required this.height,
    List<List<Color>?>? pixelColors, // Optional parameter for PixelColors
    this.key,
  }) : pixelColors = pixelColors != null ? PixelColors.input(pixelColors) : PixelColors(width, height),
       super(key: key);

  @override
  State<CreateGrid> createState() => _CreateGridState();
}

class _CreateGridState extends State<CreateGrid> {
  late PaintCubit paintCubit;
  late ColorCubit colorCubit;
  late EraseCubit eraseCubit;
  late GridListCubit gridListCubit;

  late double cellWidth;
  late double cellHeight;

  late double gridWidthFactor;
  late double gridHeightFactor;

  @override
  void initState() {
    super.initState();
    // Initialize BLoCs
    paintCubit = BlocProvider.of<PaintCubit>(context);
    colorCubit = BlocProvider.of<ColorCubit>(context);
    eraseCubit = BlocProvider.of<EraseCubit>(context);
    gridListCubit = BlocProvider.of<GridListCubit>(context);
  }

  void _calculateGridIndex(Offset localPosition, Color color) {
    final column = (localPosition.dx / cellWidth).floor().clamp(0, widget.width - 1);
    final row = (localPosition.dy / cellHeight).floor().clamp(0, widget.height - 1);
    setState(() {
      widget.pixelColors.paint(row, column, color); // Use widget.pixelColors to paint
    });
  }

  void _handleClick(Offset localPosition, ColorCubit colorCubit) {
    final column = (localPosition.dx / cellWidth).floor().clamp(0, widget.width - 1);
    final row = (localPosition.dy / cellHeight).floor().clamp(0, widget.height - 1);

    setState(() {
      if(paintCubit.state){
        if (colorCubit.state == widget.pixelColors.pixelColors[row][column]) {
          widget.pixelColors.paint(row, column, Colors.transparent);
        } else {
          widget.pixelColors.paint(row, column, colorCubit.state);
        }
      } else if (eraseCubit.state){
        widget.pixelColors.paint(row, column, Colors.transparent);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    gridWidthFactor = 0.7;
    gridHeightFactor = 0.6;

    return LayoutBuilder( //to get parent size
      builder: (context, constraints) {
        cellWidth = (constraints.maxWidth * 0.7) / widget.width;
        cellHeight = (constraints.maxHeight * 0.6) / widget.height;
        return GestureDetector(
          onTapDown: (details) {
            if (paintCubit.state || eraseCubit.state) {
              _handleClick(details.localPosition, colorCubit);
            }
          },
          onPanUpdate: (details) {
            if (paintCubit.state) {
              _calculateGridIndex(details.localPosition, colorCubit.state);
            } else if (eraseCubit.state) {
              _calculateGridIndex(details.localPosition, Colors.transparent);
            }
          },
          child: Builder(
            builder: (context) {
              try {
                return buildGrid(widget.width, widget.height);
              } catch (e) {
                print(e);
                print("issue in build grid");
                return Container(
                  child: Text("Error: Grid display issue"),
                );
              }
            },
          ),
        );
      },
    );
  }

  Widget buildGrid(int width, int height) {
    List<Widget> rows = [];

    for (int y = 0; y < height; y++) {
      List<Widget> rowChildren = [];
      for (int x = 0; x < width; x++) {
        rowChildren.add(
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                  color: widget.pixelColors.pixelColors[y][x],
                  border: Border.all(color: Colors.grey.shade400)),
            ),
          ),
        );
      }
      rows.add(Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: rowChildren,
          )));
    }

    return FractionallySizedBox(
        widthFactor: gridWidthFactor, //for editor page
        heightFactor: gridHeightFactor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: rows,
        ));
  }
}
