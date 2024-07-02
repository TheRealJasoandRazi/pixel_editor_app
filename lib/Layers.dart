import 'package:flutter/material.dart';

class Layers {
  final List<List<Color>> grid;
  List<List<Color>> editable;

  List<List<List<Color>>> listOfViews;
  List<List<List<Color>>> allLayers;

  Layers(List<List<Color>> grid) 
      : grid = grid,
        listOfViews = [grid],
        editable = grid,
        allLayers = [grid];

  void addView(List<List<Color>> layer){
    listOfViews.add(layer);
  }

  void removeView(List<List<Color>> layer){
    listOfViews.remove(layer);
  }

  void addLayer(List<List<Color>> layer){
    allLayers.add(layer);
  }

  void removeLayer(List<List<Color>> layer){
    allLayers.remove(layer);
  }

  void changeEditable(List<List<Color>> layer){
    editable = layer;
  }
}
