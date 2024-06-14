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

class EditorPage extends StatefulWidget {
  const EditorPage({Key? key}) : super(key: key);

  @override
  State<EditorPage> createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage>  with SingleTickerProviderStateMixin {
  PaintTool paintTool = PaintTool();
  EraseTool eraseTool = EraseTool();

  @override
  Widget build(BuildContext context) {
    final gridListCubit = BlocProvider.of<GridListCubit>(context);
    final colorWheelCubit = BlocProvider.of<ColorWheelCubit>(context);
    final colorCubit = BlocProvider.of<ColorCubit>(context);

    return Scaffold(
      appBar: AppBar( //TOP
        automaticallyImplyLeading: false, //need in release
        flexibleSpace: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded( 
                flex: 1,
                child: GestureDetector(
                  onTap: (){
                    Navigator.pushNamed(context, '/CreateGridPage');
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.shade400,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text("Add new grid")
                      )
                    )
                  )
                )
              ),
              Expanded( //IMPORT TOOL
                flex: 1,
                child: GestureDetector(
                  onTap: (){
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
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.shade400,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text("Import")
                      )
                    )
                  )
                ),
              ),
              Expanded( //EXPORT TOOL
                flex: 1,
                child: GestureDetector(
                  onTap: (){
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
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.shade400,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text("Export")
                      )
                    )
                  )
                ),
              ),
              Expanded( //EXPORT TOOL
                flex: 1,
                child: GestureDetector(
                  onTap: (){
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
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.shade400,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Center(
                        child: Text("Delete")
                      )
                    )
                  )
                ),
              )
            ]
          ),
        ),
      ),
      body: Row( /////BODY OF SCREEN
        children: [
          Expanded(
            flex: 1,
            child: ColorWheel(),
          ),
          Expanded(
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
      bottomNavigationBar: BottomAppBar( ////BOTTOM
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: BlocBuilder<ColorCubit, Color>(
                builder: (context, state) {
                  return Container(
                    color: colorCubit.state,
                  );
                }
              )
            ),
            Expanded(
              child: paintTool,
            ),
            Expanded(
              child: eraseTool
            ),
          ],
        ),
      )
    );
  }
}