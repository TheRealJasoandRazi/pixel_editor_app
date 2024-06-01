import 'package:flutter_bloc/flutter_bloc.dart';

class SwitchCubit extends Cubit<bool> {
  SwitchCubit() : super(false); //initial state

  void changeState() {
    emit(!state); 
  }
}