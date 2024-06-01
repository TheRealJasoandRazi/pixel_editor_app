import 'package:flutter_bloc/flutter_bloc.dart';

class PixelateCubit extends Cubit<bool> {
  PixelateCubit() : super(false); //initial state

  void changePixelateFormVisibility() {
    emit(!state); 
  }
}