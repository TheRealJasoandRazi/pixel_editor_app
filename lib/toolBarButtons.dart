import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Cubit/RotatedToolBarState.dart';

mixin ToolBarButtons {
  Widget toolBarButton(IconData icon, Function() action, Color color, BuildContext context) {
    final rotatedToolBarCubit = BlocProvider.of<RotatedToolBarCubit>(context);

    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: 0.7,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: action, // Wrap the entire container with GestureDetector
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: color,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: BlocBuilder<RotatedToolBarCubit, bool>( //rebuilds the icon based on cubit state
              builder: (context, state) {
                return AnimatedRotation(
                  turns: rotatedToolBarCubit.state ? -0.25 : 0,
                  duration: Duration(milliseconds: 300),
                  child: Icon(
                    icon,
                  ),
                );
              }
            )
          ),
        ),
      ),
    );
  } 
}