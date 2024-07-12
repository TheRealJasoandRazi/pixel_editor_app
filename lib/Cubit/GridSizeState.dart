import 'package:flutter_bloc/flutter_bloc.dart';

class GridSizeCubit extends Cubit<Map<String, int>> {
  GridSizeCubit() : super({"width": 3, "height": 3});

  void changeValues(int width, int height) {
    emit({"width": width, "height": height});
  }
}
