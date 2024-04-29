import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

mixin ToolBarButtons {
  Widget toolBarButton(IconData icon, Function() action, Color color) {
    return Flexible(
      flex: 1,
      child: FractionallySizedBox(
        widthFactor: 0.75,
        heightFactor: 0.2,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
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
            child: GestureDetector(
              onTap: action,
              child: Icon(
                icon,
              ),
            ),
          ),
        ),
      ),
    );
  }
}