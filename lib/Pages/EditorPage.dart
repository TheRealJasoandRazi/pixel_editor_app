import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_editor_app/Cubit/ColorState.dart';
import 'package:pixel_editor_app/Cubit/GridListState.dart';
import 'package:pixel_editor_app/Cubit/SelectedGridState.dart';
import 'package:pixel_editor_app/Pages/DeleteGridPage.dart';
import 'package:pixel_editor_app/Pages/LayersPage.dart';
import 'package:pixel_editor_app/Tools/DropperTool.dart';

import '../Tools/PaintTool.dart';
import '../Tools/EraseTool.dart';
import '../CreateGrid.dart';

//PAGES
import 'Export/ExportPage.dart';
import 'ImportPage.dart';

//OTHER
import '../ColorWheel.dart';
import '../Cubit/ColorWheelState.dart';
import '../ResubleWidgets/BuildGrid.dart';
import '../ResubleWidgets/PageTransitionAnimations.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({Key? key}) : super(key: key);

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage>  with SingleTickerProviderStateMixin {
  PaintTool paintTool = PaintTool();
  EraseTool eraseTool = EraseTool();
  DropperTool dropperTool = DropperTool();

  late final GridListCubit gridListCubit;
  late final SelectedGridCubit selectedGridCubit;

  late final PageTransitionAnimations pageAnimation = PageTransitionAnimations();

  Widget topBarButtons(Function() action, Color color, String text){
    return Expanded( //NEW GRID TOOL
      flex: 1,
      child: GestureDetector(
        onTap: action,
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Center(
              child: Text(text)
            )
          )
        )
      )
    );
  }

  @override
  void initState() {
    gridListCubit = context.read<GridListCubit>(); //initialise cubits
    selectedGridCubit = context.read<SelectedGridCubit>(); 
    if(gridListCubit.state.isNotEmpty && selectedGridCubit.state == null){
      selectedGridCubit.changeSelection(gridListCubit.state[0]);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorWheelCubit = BlocProvider.of<ColorWheelCubit>(context);
    final colorCubit = BlocProvider.of<ColorCubit>(context);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(MediaQuery.of(context).size.height * 0.10),
          child: AppBar(
          automaticallyImplyLeading: false, //need in release
          flexibleSpace: SafeArea(
            child: Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      topBarButtons( //NEW GRID TOOL
                        () {
                          colorWheelCubit.closeWheel();
                          Navigator.pushNamed(context, '/CreateGridPage');
                        },
                        Colors.blueAccent.shade400,
                        "Add new grid",
                      ),
                      topBarButtons( //IMPORT TOOL
                        () {
                          colorWheelCubit.closeWheel();
                          Navigator.of(context).push(
                            pageAnimation.slideUpTransition(ImportPage(previousPage: "/EditorPage"))
                          );
                        },
                        Colors.blueAccent.shade400,
                        "import"
                      ),
                      topBarButtons( //EXPORT TOOL
                        () {
                          colorWheelCubit.closeWheel();
                          Navigator.push(
                            context,
                            pageAnimation.fadeInTransition(ExportPage())
                          );
                        },
                        Colors.blueAccent.shade400,
                        "Export"
                      ),
                      topBarButtons( //DELETE BUTTON
                        (){
                          colorWheelCubit.closeWheel();
                          Navigator.push(
                            context,
                            pageAnimation.fadeInTransition(DeleteGridPage())
                          );
                        },
                        Colors.blueAccent.shade400,
                        "Delete"
                      ),
                    ]
                  ),
                ),
                Expanded( //LIST OF GRIDS (REPLICA NOT WORKING)
                  flex: 1,
                  child: BlocBuilder<GridListCubit, List<CreateGrid>>( //unneccessary
                    builder: (context, state) {
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: state.length,
                        itemBuilder: (context, index) {
                          final itemWidth = screenWidth / 12.0;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if(selectedGridCubit.state != state[index]){
                                  selectedGridCubit.changeSelection(state[index]);
                                } else {
                                  selectedGridCubit.changeSelection(null);
                                }
                              });
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: itemWidth,
                                  child: Builder(
                                    builder: (context) {
                                      bool widget = selectedGridCubit.state == state[index]; //always returning false
                                      return widget ? //if the grid is the same as the selected grid, wrap it in a value notifier
                                      ListenableBuilder( //index of selected grid
                                        listenable: selectedGridCubit.state!.pixelColors,
                                        builder: (context, child) {
                                          return Container(
                                            child: RepaintBoundary( //only rebuild child not entire page
                                              child: BuildGrid( //create replica under a value notifer
                                                grid: state[index],
                                                selected: true, 
                                                widthFactor: 0.9, 
                                                heightFactor: 0.9
                                              )
                                            )
                                          ); 
                                        }
                                      )
                                    : BuildGrid(grid: state[index], selected: false, widthFactor: 0.9, heightFactor: 0.9,);
                                    }
                                  )
                                ),
                              ],
                            )
                          );
                        }
                      );
                    }
                  )
                )
              ]
            ),
          ),
        ),
      ),
      body: Row( /////BODY OF SCREEN
        children: [
          Expanded( ///COLOR WHEEL
            flex: 1,
            child: ColorWheel(),
          ),
          Expanded( //SELECTED GRID
            flex: 3,
            child: BlocListener<ColorWheelCubit, bool>(
              listener: (context, state) {
                // Handle state changes here, if needed
              },
              child: RepaintBoundary(
                child: AnimatedAlign( //ANIMATION DOESN'T WORK
                  alignment: context.watch<ColorWheelCubit>().state
                      ? Alignment.center
                      : Alignment.centerLeft,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: BlocBuilder<SelectedGridCubit, CreateGrid?>(
                  builder: (context, state) {
                    if(state != null){
                      return state;
                    } else {
                      return Container();
                    }
                  }
                )
                ),
              )
            )
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar( ////BOTTOM BAR
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded( //SHOWS CURRENT COLOR 
              child: BlocBuilder<ColorCubit, Color>(
                builder: (context, state) {
                  return Container(
                    color: colorCubit.state,
                  );
                }
              )
            ),
            Expanded( //temporary code
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: GestureDetector(
                  onTap: () {
                    colorWheelCubit.closeWheel();
                    Navigator.of(context).push(
                      pageAnimation.slideUpTransition(LayersPage())
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.layers,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded( // PAINT TOOL
              child: paintTool,
            ),
            Expanded( // ERASE TOOL
              child: eraseTool
            ),
            Expanded( // DROPPER TOOl
              child: dropperTool
            ),
          ],
        ),
      )
    );
  }
}