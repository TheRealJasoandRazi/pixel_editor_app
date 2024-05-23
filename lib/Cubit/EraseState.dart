import 'package:flutter_bloc/flutter_bloc.dart';

class EraseCubit extends Cubit<bool> {
  EraseCubit() : super(false); //initial state

  void changeSelection() {
    emit(!state); //emit function changes the state for you
  }
}