import 'package:flutter/material.dart';

class SnackBarMessage extends StatelessWidget { //doesn't work
  final String message;

  const SnackBarMessage({
    required this.message,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Center(
          child: Text(message),
        ),
      ),
    );
    return Container();
  }
}
