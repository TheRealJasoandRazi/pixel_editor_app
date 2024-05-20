import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RotatedToolBarCubit extends Cubit<bool> {
  RotatedToolBarCubit() : super(false); //initial state

  void changeState(bool newState) {
    emit(newState); //emit function changes the state for you
  }
}