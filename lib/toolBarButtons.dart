import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Cubit/SwitchState.dart';

mixin ToolBarButtons {
  Widget toolBarButton(IconData icon, Function() action, Color color, String text) {

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: GestureDetector(
          onTap: action, // Wrap the entire container with GestureDetector
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: color,
            ),
            child: Center( //without this, the container will only expand to fit the widget
              child: Icon(
                color: Colors.black,
                icon,
              )
            )
          ),
        ),
      ),
    );
  } 
}