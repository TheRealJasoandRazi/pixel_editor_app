import 'package:flutter/material.dart';
import 'package:pixel_editor_app/Cubit/LayersSideBarState.dart';
import 'Cubit/SelectedGridState.dart';
import 'Cubit/GridListState.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import "ResubleWidgets/BuildGrid.dart";

class LayersSlider extends StatefulWidget {
  const LayersSlider({super.key});

  @override
  State<LayersSlider> createState() => _LayersSliderState();
}

class _LayersSliderState extends State<LayersSlider>  with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  bool sideBar = false;

  late GridListCubit gridListCubit;
  late SelectedGridCubit selectedGridCubit;
  late LayersSideBarCubit layersSideBarCubit;

  @override
  void initState() {
    super.initState();

    gridListCubit = context.read<GridListCubit>(); 
    selectedGridCubit = context.read<SelectedGridCubit>(); 
    layersSideBarCubit = context.read<LayersSideBarCubit>();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleSidebar() {
    setState(() {
      sideBar = !sideBar;
      if (sideBar) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LayersSideBarCubit, bool>(
      listener: (context, state) {
        if (state) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      child: SlideTransition(
        position: _offsetAnimation,
        child: FractionallySizedBox(
          heightFactor: 0.5,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: listLayers(),
          ),
        ),
      ),
    );
  }

  Widget listLayers(){
    if(gridListCubit.state.length == 0 || selectedGridCubit.state == null){
      return Center(
        child: Text(
          "No grid selected"
        ),
      );
    }
    final grid = gridListCubit.state[selectedGridCubit.state!];

    return ListenableBuilder( //Rebuild Sidebar whenever paint is done on the editor page
      listenable: grid, 
      builder:(context, child) {
        return LayoutBuilder(
          builder: (context, constraints) {
            final containerWidthSize = constraints.maxWidth / 5;
            final containerHeightSize = constraints.maxHeight / 5;
            return ListView.builder(
              itemCount: grid.allLayers.length,
              itemBuilder: (context, index) {
                final layer = grid.allLayers[index];
                return Container(
                  width: containerWidthSize,
                  height: containerHeightSize,
                  child: Row(
                    children: [
                      Expanded(
                        child: BuildGrid(
                          pixelColors: grid.allLayers[index],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (grid.isViewable(layer)) {
                              grid.removeView(layer);
                            } else {
                              grid.addView(layer);
                            }
                          });
                        },
                        child: Opacity(
                          opacity: grid.isViewable(layer) ? 1.0 : 0.5,
                          child: Container(
                            child: Center(
                              child: Icon(Icons.remove_red_eye),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      }
    );
  }
}