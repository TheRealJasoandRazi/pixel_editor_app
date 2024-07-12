import 'dart:js_interop';

import 'package:flutter/material.dart';
import 'package:pixel_editor_app/ResubleWidgets/BuildGrid.dart';

class Grid with ChangeNotifier {
  late int editable; //index of editable layer in list of views

  late List<Layer> listOfViews;
  late List<Layer> allLayers;

  late int height;
  late int width;
  int layerCount = 1;

  Grid(int aWidth, int aHeight) {
    width = aWidth;
    height = aHeight;
    Layer firstLayer = Layer(width, height, "Layer ${layerCount}");
    listOfViews = [firstLayer];
    editable = 0;
    allLayers = [firstLayer];
  }

  Grid.import(List<List<Color>> aLayout){
    width = aLayout[0].length;
    height = aLayout.length;
    Layer firstLayer = Layer.import(aLayout,"Layer ${layerCount}");
    listOfViews = [firstLayer];
    editable = 0;
    allLayers = [firstLayer];
  }

  void rotateLayer(Layer layer) {
    int index = allLayers.indexOf(layer);
    if(index == -1){
      return;
    }

    int rows = layer.layout.length;
    int cols = layer.layout[0].length;
    Layer rotatedLayer = Layer(width, height, layer.name);

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        // Assign the current element to the rotated matrix in a clockwise manner
        rotatedLayer.layout[j][rows - 1 - i] = layer.layout[i][j];
      }  //no idea how "rows - 1 - i" works
    }

    //update grid in list
    allLayers[index] = rotatedLayer;
    notifyListeners(); //refresh page
  }

  void reflectLayer(Layer layer){
    int index = allLayers.indexOf(layer);
    if(index == -1){
      return;
    }

    for(int row = 0; row < height; row++){
      allLayers[index].layout[row] = allLayers[index].layout[row].reversed.toList();
    }
    notifyListeners(); //refresh page
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
    return Layer(width, height, "Layer ${layerCount}");
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
    notifyListeners(); //for refresh from layer side bar
  }

  void addView(Layer layer){
    if(!listOfViews.contains(layer)){
      listOfViews.add(layer);
    }
    notifyListeners(); //for refresh from layer side bar
  }

  void addLayer(){
    layerCount++;
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

  void swapLayers(Layer layer, String action) {
    int index = allLayers.indexOf(layer);
    
    if (index == -1) {
      return;
    }

    if (action == "up" && index > 0) {
      // Swap with the layer above
      Layer temp = allLayers[index];
      allLayers[index] = allLayers[index - 1];
      allLayers[index - 1] = temp;
    } else if (action == "down" && index < allLayers.length - 1) {
      // Swap with the layer below
      Layer temp = allLayers[index];
      allLayers[index] = allLayers[index + 1];
      allLayers[index + 1] = temp;
    }
    notifyListeners(); //rebuild layers list when moving positions
  }

  void mergeLayers(Layer layer, String action){ //LAYERS LISTED BELOW HAVE DOMINANCE
    int currentLayerIndex = allLayers.indexOf(layer);
    if(currentLayerIndex == -1){
      return;
    }

    int? otherLayerIndex;
    if(action == "down"){
      otherLayerIndex = currentLayerIndex + 1; //gets layer index below
      if(otherLayerIndex >= allLayers.length){
        return; //another safety check, that index is valid/exists
      }
    } else if(action == "up"){
      otherLayerIndex = currentLayerIndex - 1;
      if(otherLayerIndex < 0){
        return; 
      }
    }

    Layer newLayer = Layer(width, height, "new merged layer"); 
    for(int row = 0; row < height; row++){
      for(int col = 0; col < width; col++){

        if(action == "up"){ //first check current layer for color
          Color color = layer.getColor(row, col); //get current layer color
          if(color != Colors.transparent){
            newLayer.paint(row, col, color);
          } else {
            Color otherLayerColor = allLayers[otherLayerIndex!].getColor(row, col);
            newLayer.paint(row, col, otherLayerColor);
          }
        }
        else if(action == "down"){ //check below layer for color first
          Color color = allLayers[otherLayerIndex!].getColor(row, col);
          if(color != Colors.transparent){
            newLayer.paint(row, col, color);
          } else {
            Color otherLayerColor = layer.getColor(row, col);
            newLayer.paint(row, col, otherLayerColor);
          }
        }
      }
    }
    //remove one of the layers, replace current layer, and delete other layer
    allLayers[currentLayerIndex] = newLayer;
    allLayers.remove(allLayers[otherLayerIndex!]);
    notifyListeners(); //REFRESHES LAYERSPAGE
  }

  void removeLayer(Layer layer){ //when you deletinng the last listofview index, it crashes because editable has nothing to point to
    int index = listOfViews.indexOf(layer);
    if(index == editable){
      editable = 0; //in case user deletes layer tahts editables
    }
    if(allLayers.contains(layer)){ //remove from allLayers
      allLayers.remove(layer);
    } else if(listOfViews.contains(layer)){ //remove from listofViews
      listOfViews.remove(layer);
    }
    notifyListeners();
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

  Layer(int width, int height, String aName){
    layout =  List.generate(height, (_) => List.filled(width, Colors.transparent));
    name = aName;
  }

  Layer.import(List<List<Color>> grid, String aName){
    layout = grid;
    name = aName;
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
