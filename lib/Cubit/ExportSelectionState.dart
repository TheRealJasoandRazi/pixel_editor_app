import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_editor_app/CreateGrid.dart';

class ExportSelectionCubit extends Cubit<List<CreateGrid>> {
  ExportSelectionCubit() : super([]); // Initial state is an empty list

  void addGrid(CreateGrid grid) {
    emit([...state, grid]); // Add the grid to the list
  }

  void removeSelectedGrid(CreateGrid inputGrid) {
    List<CreateGrid> newList = state.where((grid) => grid != inputGrid).toList();
    emit(newList); // Remove the specified grid from the list
  }

  bool containsGrid(CreateGrid grid) {
    return state.contains(grid); // Check if the list contains the specified grid
  }

  void clearList() {
    emit([]); // Emit an empty list to remove all elements
  }
}
