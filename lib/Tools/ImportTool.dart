import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_editor_app/Cubit/EraseState.dart';
import 'package:pixel_editor_app/Cubit/ImageListState.dart';

import '../toolBarButtons.dart';
import '../Cubit/ExportState.dart';
import '../Cubit/PaintState.dart';
import '../Cubit/FormState.dart';

import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:typed_data';

import '../ImageWrapper.dart';

class ImportTool extends StatefulWidget {
  @override
  _ImportToolState createState() => _ImportToolState();
}

class _ImportToolState extends State<ImportTool> with ToolBarButtons {
  Future<Uint8List?> _selectFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.isNotEmpty) {
      return result.files.first.bytes;
    }
    return null;
  }
  
  @override
  Widget build(BuildContext context) {
    final imageListCubit = BlocProvider.of<ImageListCubit>(context);

    return toolBarButton(
      Icons.outbond,
      () async {
        final image = await _selectFile();
        if (image != null) {
          imageListCubit.addImage(ImageWrapper(image: image));
        }
        print(imageListCubit.state);
      },
      Colors.grey.shade300,
      context
    );
  }
}


 /*final exportCubit = BlocProvider.of<ExportCubit>(context); //retieve form state
    final paintCubit = BlocProvider.of<PaintCubit>(context); //retieve form state
    final formCubit = BlocProvider.of<FormCubit>(context); //retieve form state
    final eraseCubit = BlocProvider.of<EraseCubit>(context);*/