import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_editor_app/Cubit/PopUpState.dart';
import 'package:pixel_editor_app/ResubleWidgets/ToolTipPainter.dart';
import '../main.dart'; // Import the main.dart file to access routeObserver

class ToolBarButton extends StatefulWidget {
  final IconData icon;
  final Function() action;
  final Color color;
  final String text;
  final String tool;

  const ToolBarButton({
    Key? key,
    required this.icon,
    required this.action,
    required this.color,
    required this.text,
    required this.tool,
  }) : super(key: key);

  @override
  _ToolBarButtonState createState() => _ToolBarButtonState();
}

class _ToolBarButtonState extends State<ToolBarButton> with RouteAware {
  OverlayEntry? _overlayEntry;

  @override
  void didChangeDependencies() { //executes when dependencies such as inherited widgets, route info etc.
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context) as PageRoute); 
  }

  @override
  void didPushNext() {
    _removeOverlay();
  }

  @override
  void dispose() {
    _removeOverlay();
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createToolTip(BuildContext context, String text) {
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

  @override
  Widget build(BuildContext context) {
    final popUpCubit = BlocProvider.of<PopUpCubit>(context);

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GestureDetector(
        onTap: () {
          widget.action();
          if (popUpCubit.returnState(widget.tool) == false) {
            if (_overlayEntry == null) {
              _overlayEntry = _createToolTip(context, widget.text);
              Overlay.of(context).insert(_overlayEntry!);
              popUpCubit.turnTrue(widget.tool);
            }
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: widget.color,
          ),
          child: Center(
            child: Icon(
              widget.icon,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
