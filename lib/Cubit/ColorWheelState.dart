import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorWheelCubit extends Cubit<bool> {
  ColorWheelCubit() : super(false); //initial state

  void changeColorWheelVisibility() {
    emit(!state); //emit function changes the state for you
  }
}