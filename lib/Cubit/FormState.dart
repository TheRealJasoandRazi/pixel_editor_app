import 'package:flutter_bloc/flutter_bloc.dart';

class FormCubit extends Cubit<bool> {
  FormCubit() : super(false); //initial state

  void changeFormVisibility() {
    emit(!state); 
  }
}