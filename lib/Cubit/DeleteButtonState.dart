import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteButtonCubit extends Cubit<bool> {
  DeleteButtonCubit() : super(false); //initial state

  void changeState() {
    emit(!state); //emit function changes the state for you
  }
}