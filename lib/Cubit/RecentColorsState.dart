import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class RecentColorsCubit extends Cubit<List<Color>> {
  RecentColorsCubit() : super([Colors.blue]); // Initial state

  void addColor(Color newColor) {
    if(!state.contains(newColor)){ //not already in recent colors
      if(state.length < 3){
        final updatedColors = List<Color>.from(state);
        updatedColors.add(newColor);
        emit(updatedColors);
      } else {
        final updatedColors = List<Color>.from(state);
        updatedColors.removeAt(0); //remove first color
        updatedColors.add(newColor);
        emit(updatedColors);
      }
    }
  }
}