import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_editor_app/Cubit/ColorState.dart';
import 'package:pixel_editor_app/Cubit/GridListState.dart';
import 'package:pixel_editor_app/Pages/DeleteGridPage.dart';

import '../Tools/PaintTool.dart';
import '../Tools/EraseTool.dart';
import '../CreateGrid.dart';

//PAGES
import 'ExportPage.dart';
import 'ImportPage.dart';

//OTHER
import '../ColorWheel.dart';
import '../Cubit/ColorWheelState.dart';
import '../ResubleWidgets/BuildGrid.dart';

class EditorPage extends StatefulWidget {
  const EditorPage({Key? key}) : super(key: key);

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage>  with SingleTickerProviderStateMixin{
  PaintTool paintTool = PaintTool();
  EraseTool eraseTool = EraseTool();
  List<String> test = ["ass", "test", "boo"];

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
  Widget build(BuildContext context) {
    final gridListCubit = BlocProvider.of<GridListCubit>(context);
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
                            PageRouteBuilder(
                              pageBuilder: (context, animation, secondaryAnimation){
                                return ImportPage(previousPage: "/EditorPage");
                              },
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                const begin = Offset(0.0, 1.0); // Start from the bottom
                                const end = Offset.zero; // End at the original position
                                const curve = Curves.ease;

                                var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
                                var offsetAnimation = animation.drive(tween);

                                return SlideTransition(
                                  position: offsetAnimation,
                                  child: child,
                                );
                              },
                              transitionDuration: Duration(milliseconds: 300),
                            ),
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
                            PageRouteBuilder( //NEED TO LEARN THIS
                              pageBuilder: (context, animation, secondaryAnimation) {
                                return ExportPage();
                              },
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: Tween<double>(
                                    begin: 0.0,
                                    end: 1.0,
                                  ).animate(animation),
                                  child: child,
                                );
                              },
                            )
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
                            PageRouteBuilder( //NEED TO LEARN THIS
                              pageBuilder: (context, animation, secondaryAnimation) {
                                return DeleteGridPage();
                              },
                              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                return FadeTransition(
                                  opacity: Tween<double>(
                                    begin: 0.0,
                                    end: 1.0,
                                  ).animate(animation),
                                  child: child,
                                );
                              },
                            )
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
                            onTapDown: (details) {
                              print("test");
                            },
                            child: Row(
                              children: [
                                Container(
                                  width: itemWidth,
                                  child: BuildGrid(grid: state[index])
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
            
              child: AnimatedAlign( //ANIMATION DOESN'T WORK
                alignment: context.watch<ColorWheelCubit>().state
                    ? Alignment.center
                    : Alignment.centerLeft,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: BlocBuilder<GridListCubit, List<CreateGrid>>(
                  builder: (context, state) {
                    if(state.isNotEmpty){
                      return state[0];
                    } else {
                      return Container();
                    }
                  }
                )
              ),
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
            Expanded( // PAINT TOOL
              child: paintTool,
            ),
            Expanded( // ERASE TOOL
              child: eraseTool
            ),
          ],
        ),
      )
    );
  }
}