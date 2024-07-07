import 'package:flutter_bloc/flutter_bloc.dart';
import '../Grid.dart';

class GridListCubit extends Cubit<List<Grid>> {
  GridListCubit() : super([]); //initial state

  void addGrid(Grid newGrid){
    emit(List.from(state)..add(newGrid));
  }

  void removeGridAtIndex(int index) {
    final updatedList = List<Grid>.from(state);
    if (index >= 0 && index < updatedList.length) {
      updatedList.removeAt(index);
      emit(updatedList);
    }
  }
}