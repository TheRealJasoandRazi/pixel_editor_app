import 'package:flutter/material.dart';
import 'PaintTool.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Cubit/ColorState.dart';
import 'Cubit/PaintState.dart';

class GridItem extends StatefulWidget {
  final int index;

  const GridItem({
    Key? key, 
    required this.index,
  }) : super(key: key);

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  Color defaultColor = Colors.transparent;
  late Color currentColor;

  @override
  void initState() {
    super.initState();
    currentColor = defaultColor;
  }

  void _handleClick(ColorCubit colorCubit) {
    setState(() {
      if(colorCubit.state == currentColor){
        currentColor = Colors.transparent;
      } else {
        currentColor = colorCubit.state;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorCubit = BlocProvider.of<ColorCubit>(context); //retieve form state
    final paintCubit = BlocProvider.of<PaintCubit>(context); //retieve form state

    return GestureDetector(
      onTap:() {
        if(paintCubit.state)
          _handleClick(colorCubit);
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          color: currentColor,
        ),
      ),
    );
  }
}
