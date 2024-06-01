import 'package:flutter/material.dart';
import '../toolBarButtons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Cubit/SwitchState.dart';

class SwitchTool extends StatelessWidget with ToolBarButtons {
  @override
  Widget build(BuildContext context) {
    final switchCubit = BlocProvider.of<SwitchCubit>(context);

    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: 0.8,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: (){
            switchCubit.changeState();
          }, // Wrap the entire container with GestureDetector
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.grey.shade300,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                "Switch",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center, // Center align the text
              )
            ),
          ),
        ),
      ),
    );
  }
}