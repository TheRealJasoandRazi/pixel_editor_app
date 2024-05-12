import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorCubit extends Cubit<Color> {
  ColorCubit() : super(Colors.blue); //initial state

  void changeColor(Color color) {
    emit(color); //emit function changes the state for you
  }
}