import 'package:flutter/material.dart';
import 'package:pixel_editor_app/ResubleWidgets/BuildGrid.dart';

class Layers with ChangeNotifier {
  int editable; //index of editable layer in list of views

  List<List<List<Color>>> listOfViews;
  List<List<List<Color>>> allLayers;

  final int height;
  final int width;

  Layers(List<List<Color>> grid) 
      : listOfViews = [grid],
        editable = 0,
        allLayers = [grid],
        height = grid.length,
        width = grid[0].length;

  List<List<Color>> createLayer(){
    return List.generate(height, (_) => 
      List.filled(width, Colors.transparent));
  }

  bool isViewable(List<List<Color>> layer) {
    return listOfViews.contains(layer);
  }

  bool isEditable(List<List<Color>> layer) {
    return listOfViews[editable] == layer;
  }

  void removeView(List<List<Color>> layer){
    if(listOfViews.contains(layer)){ //if currently viewable
      int index = listOfViews.indexOf(layer);
      if(index < editable){
        editable = editable - 1;
        listOfViews.remove(layer);
      }
      else {
        if(listOfViews.length > 1){
          listOfViews.remove(layer);
        }
      }
    }
  }

  void addView(List<List<Color>> layer){
    if(!listOfViews.contains(layer)){
      listOfViews.add(layer);
    }
  }

  void addLayer(){
    allLayers.add(createLayer());
  }

  List<Widget> displayInStack(bool selected, bool exporting){
    List<Widget> list = [];
    for(var layer in allLayers){
      list.add(
        BuildGrid(
          pixelColors: layer,
          selected: selected,
          exporting: exporting,
        )
      );
    }
    return list;
  }

  void removeLayer(List<List<Color>> layer){
    if(listOfViews.contains(layer)){
      int index = listOfViews.indexOf(layer);
      if(index == editable){
        editable = 0; //in case user deletes layer tahts editables
      }
    }
    allLayers.remove(layer);
  }

  void editLayer(int row, int col, Color color){ //paint the layers directly using this
    listOfViews[editable][row][col] = color;
    notifyListeners();
  }

  Color getColor(int row, int col){
    return listOfViews[editable][row][col];
  }

  void changeEditable(List<List<Color>> layer){
    if(listOfViews.contains(layer)){ //if currently viewable
      int index = listOfViews.indexOf(layer);
      editable = index;
    } else if(allLayers.contains(layer)){ //if not currently viewable
      addView(layer);
      int index = listOfViews.indexOf(layer);
      editable = index;
    }
  }
}
