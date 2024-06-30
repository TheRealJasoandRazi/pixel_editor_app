import 'package:flutter/material.dart';
import 'package:pixel_editor_app/Cubit/PopUpState.dart';
import 'package:pixel_editor_app/ResubleWidgets/ToolTipPainter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin ToolBarButtons { //on RouteAware
  OverlayEntry? _overlayEntry;
/*
  @override
  void didPushNext() {
    // Called when a route is pushed on top of this route
    // You can perform actions when another page is pushed on top
    _removeOverlay();
  }
*/

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }


  Widget toolBarButton(IconData icon, Function() action, Color color, String text, BuildContext context, String tool) {
    final popUpCubit = BlocProvider.of<PopUpCubit>(context); 

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: GestureDetector(
          onTap: () {
            action();
            if(popUpCubit.returnState(tool) == false){ //checks popup hasn't showed before
              if(_overlayEntry == null){ //makee sure its only made once
                _overlayEntry = toolTip(context, text);
                Overlay.of(context).insert(_overlayEntry!);
                popUpCubit.turnTrue(tool); //turns to true, so pop up wont show again
              }
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: color,
            ),
            child: Center(
              child: Icon(
                icon,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  OverlayEntry toolTip(BuildContext context, String text) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return OverlayEntry(
      builder: (context) {
        return Positioned(
          top: offset.dy - screenHeight * 0.19,
          left: offset.dx + screenWidth * 0.03,
          child: Material(
            child: CustomPaint(
              painter: ToolTipPainter(),
              child: Container(
                width: screenHeight * 0.15,
                height: screenHeight * 0.15,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        text,
                        style: TextStyle(color: Colors.black),
                      ),
                      IconButton(
                        onPressed: _removeOverlay,
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}