import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_editor_app/CreateGrid.dart';
import 'dart:collection';
import '../Layers.dart';

class GridListCubit extends Cubit<List<CreateGrid>> {
  GridListCubit() : super([]); //initial state

  void addGrid(CreateGrid grid){
    emit([...state, grid]); //"...state" creates a new list and adds grid to it
  }

  void removeGridAtIndex(int index) {
    final updatedList = List<CreateGrid>.from(state);
    if (index >= 0 && index < updatedList.length) {
      updatedList.removeAt(index);
      emit(updatedList);
    }
  }
}

/*class GridListCubit extends Cubit<HashMap<int, Layers>> {
  GridListCubit() : super(HashMap<int, Layers>()); //initial state

  void addGrid(List<List<Color>> grid){
    int index = state.length - 1;
    Layers newGrid = Layers(grid);
    emit(HashMap<int, Layers>.from(state)..[index] = newGrid);
  }
}*/