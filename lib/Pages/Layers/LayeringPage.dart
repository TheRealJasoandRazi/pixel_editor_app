import 'package:flutter/material.dart';
import '../../CreateGrid.dart';

class LayeringPage extends StatefulWidget {
  final List<CreateGrid> initialListOfLayers;

  const LayeringPage({
    super.key,
    required this.initialListOfLayers,
  });

  @override
  State<LayeringPage> createState() => _LayeringPageState();
}

class _LayeringPageState extends State<LayeringPage> {
  late List<CreateGrid> listOfLayers;

  @override
  void initState() {
    super.initState();
    listOfLayers = widget.initialListOfLayers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center()
    );
  }
}

