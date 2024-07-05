import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedGridCubit extends Cubit<int?> {
  SelectedGridCubit() : super(null); //initial state

  void changeSelection(int? index){
    emit(index);
  }
}