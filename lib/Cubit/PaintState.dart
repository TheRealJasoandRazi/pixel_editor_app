import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PaintCubit extends Cubit<bool> {
  PaintCubit() : super(false); //initial state

  void changeSelection() {
    emit(!state); //emit function changes the state for you
  }
}