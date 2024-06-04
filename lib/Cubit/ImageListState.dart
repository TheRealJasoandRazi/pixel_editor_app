import 'package:flutter_bloc/flutter_bloc.dart';
import '../ImageWrapper.dart';

class ImageListCubit extends Cubit<List<ImageWrapper>> {
  ImageListCubit() : super([]); //initial state

  void addImage(ImageWrapper image){
    emit([...state, image]); 
  }

  void removeSelectedImages() {
    List<ImageWrapper> newList = state.where((grid) => !grid.selected).toList();
    emit(newList);
  }
}