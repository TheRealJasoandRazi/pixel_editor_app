import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Cubit/SwitchState.dart';

mixin ToolBarButtons {
  Widget toolBarButton(IconData icon, Function() action, Color color, String text) {

    return FractionallySizedBox(
      widthFactor: 1,
      heightFactor: 1,
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
            child: BlocBuilder<SwitchCubit, bool>(
              builder: (context, state) {
                if(!state){
                  return Icon(
                    icon,
                  );
                } else {
                  return Center(
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center, // Center align the text
                    )
                  );
                }
              }
            )
          ),
        ),
      ),
    );
  } 
}