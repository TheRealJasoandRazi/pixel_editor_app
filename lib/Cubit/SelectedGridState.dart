import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_editor_app/CreateGrid.dart';

class SelectedGridCubit extends Cubit<CreateGrid?> {
  SelectedGridCubit() : super(null); //initial state

  void changeSelection(CreateGrid? grid){
    emit(grid);
  }
}