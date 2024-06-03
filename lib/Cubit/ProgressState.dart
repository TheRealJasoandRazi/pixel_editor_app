import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProgressCubit extends Cubit<ProgressState> {
  ProgressCubit() : super(ProgressState(progress: 0.0, text: "", visible: false)); //initial state

  void updateProgress(double currentProgress, String text, bool visible) {
    emit(ProgressState(progress: currentProgress, text: text, visible: visible));
  }
}

class ProgressState {
  final double progress;
  final String text;
  final bool visible;

  ProgressState({required this.progress, required this.text, required this.visible});
}