import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_editor_app/CreateGrid.dart';

class GridListCubit extends Cubit<List<CreateGrid>> {
  GridListCubit() : super([]); //initial state

  void addGrid(CreateGrid grid){
    emit([...state, grid]); //"...state" creates a new list and adds grid to it
  }

  void removeSelectedGrids() { //create new list without the selected grids
    List<CreateGrid> newList = state.where((grid) => !grid.selected).toList();
    emit(newList);
  }
}