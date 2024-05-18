import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GridSelectedCubit extends Cubit<bool> {
  GridSelectedCubit() : super(false); //initial state

  void changeGridVisibility() {
    emit(!state);
  }
}