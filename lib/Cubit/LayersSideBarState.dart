import 'package:flutter_bloc/flutter_bloc.dart';

class LayersSideBarCubit extends Cubit<bool> {
  LayersSideBarCubit() : super(false); //true means its open

  void toggleSideBar() {
    emit(!state); //emit function changes the state for you
  }

  void closeSideBar(){
    emit(false);
  }
}