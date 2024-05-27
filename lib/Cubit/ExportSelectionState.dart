import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ExportSelectionCubit extends Cubit<List<GlobalKey>> {
  ExportSelectionCubit() : super([]); //initial state

  void addKey(GlobalKey key){
    emit([...state, key]); //"...state" creates a new list and adds key to it
  }

  void removeSelectedKey(GlobalKey inputKey) { //remove selected key
    List<GlobalKey> newList = state.where((key) => key != inputKey).toList();
    emit(newList);
  }

  bool containsKey(GlobalKey key) {
    return state.contains(key);
  }

  void clearList() {
    emit([]); // Emit an empty list to remove all elements
  }
}