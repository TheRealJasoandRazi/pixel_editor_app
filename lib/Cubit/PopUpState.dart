import 'package:flutter_bloc/flutter_bloc.dart';

class PopUpCubit extends Cubit<Map<String, bool>> {
  PopUpCubit() : super({
    'painter': false,
    'eraser': false,
    'dropper': false
  });

  void turnTrue(String key) {
    if (state.containsKey(key)) {
      emit({...state, key: true});
    }
  }

  bool? returnState(String key){
    if(state.containsKey(key)){
      return state[key];
    }
    return null;
  }
}
