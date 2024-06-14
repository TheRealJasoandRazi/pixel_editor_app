import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ColorWheelCubit extends Cubit<bool> {
  ColorWheelCubit() : super(false); //true means its open

  void toggleColorWheel() {
    emit(!state); //emit function changes the state for you
  }

  void closeWheel(){
    emit(false);
  }
}