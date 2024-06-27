import 'package:flutter_bloc/flutter_bloc.dart';

class DropperCubit extends Cubit<bool> {
  DropperCubit() : super(false); //initial state

  void changeSelection() {
    emit(!state); //emit function changes the state for you
  }
}