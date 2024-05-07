import 'package:flutter/material.dart';

mixin ToolBarButtons {
  Widget toolBarButton(IconData icon, Function() action, Color color) {
      return FractionallySizedBox(
      widthFactor: 0.8,
      heightFactor: 0.4,
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
            child: Icon(
              icon,
            ),
          ),
        ),
      ),
    );
  } 
}