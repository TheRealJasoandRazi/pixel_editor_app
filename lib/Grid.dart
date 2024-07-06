import 'package:flutter/material.dart';
import 'package:pixel_editor_app/ResubleWidgets/BuildGrid.dart';

class Grid with ChangeNotifier {
  late int editable; //index of editable layer in list of views

  late List<Layer> listOfViews;
  late List<Layer> allLayers;

  late int height;
  late int width;

  Grid(List<List<Color>> grid) {
    height = grid.length;
    width = grid[0].length;
    Layer firstLayer = Layer(width, height, "Layer 1");
    listOfViews = [firstLayer];
    editable = 0;
    allLayers = [firstLayer];
  }

  void changeLayerName(Layer layer, String name){
    int index = allLayers.indexOf(layer);
    if(index != -1){ //if layer exists
      allLayers[index].changeName(name);
    }
  }

  void changeLayerOpacity(Layer layer, double opacity){
    int index = allLayers.indexOf(layer);
    if(index != -1){ //if layer exists
      allLayers[index].changeOpacity(opacity);
    }
  }

  Layer createLayer(){
    return Layer(width, height, "Layer ${allLayers.length}");
  }

  bool isViewable(Layer layer) {
    return listOfViews.contains(layer);
  }

  bool isEditable(Layer layer) {
    return listOfViews[editable] == layer;
  }

  void removeView(Layer layer){
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

  void addView(Layer layer){
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

  void removeLayer(Layer layer){
    if(listOfViews.contains(layer)){
      int index = listOfViews.indexOf(layer);
      if(index == editable){
        editable = 0; //in case user deletes layer tahts editables
      }
    }
    allLayers.remove(layer);
  }

  void editLayer(int row, int col, Color color){ //paint theGrid directly using this
    listOfViews[editable].paint(row, col, color);
    notifyListeners();
  }

  Color getColor(int row, int col){
    return listOfViews[editable].getColor(row, col);
  }

  void changeEditable(Layer layer){
    if(listOfViews.contains(layer)){ //if currently viewable
      int index = listOfViews.indexOf(layer);
      editable = index;
    } else if(allLayers.contains(layer)){ //if not currently viewable
      addView(layer);
      int index = listOfViews.indexOf(layer);
      editable = index;
    }
    notifyListeners();
  }
}

class Layer{
  double opacity = 1.0;
  late String name;
  late List<List<Color>> layout;

  Layer(int width, int height, String name){
    layout =  List.generate(height, (_) => List.filled(width, Colors.transparent));
    name = name;
  }

  void paint(int row, int col, Color color){
    layout[row][col] = color;
  }

  Color getColor(int row, int col){
    return layout[row][col];
  }

  void changeName(String newName){
    name = newName;
  }

  void changeOpacity(double newOpacity){
    opacity = newOpacity;
  }
}
