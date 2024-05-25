import 'package:flutter_bloc/flutter_bloc.dart';

class ExportCubit extends Cubit<bool> {
  ExportCubit() : super(false); //initial state

  void changeExportFormVisibility() {
    emit(!state); //emit function changes the state for you
  }
}