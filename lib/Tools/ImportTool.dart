import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pixel_editor_app/Cubit/ImageListState.dart';

import '../toolBarButtons.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:typed_data';

import 'dart:ui' as ui;

import '../ImageWrapper.dart';

class ImportTool extends StatefulWidget {
  @override
  _ImportToolState createState() => _ImportToolState();
}

class _ImportToolState extends State<ImportTool> with ToolBarButtons {
  late double imageWidth;
  late double imageHeight;

  Future<Uint8List?> _selectFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png', 'jpeg'], // Allow only PNG and Jpeg files
    );
    if (result != null && result.files.isNotEmpty) {
      final image = result.files.first.bytes;
      ui.Codec codec = await ui.instantiateImageCodec(image!);
      ui.FrameInfo frameInfo = await codec.getNextFrame();
      imageWidth = frameInfo.image.width.toDouble();
      imageHeight = frameInfo.image.height.toDouble();
      return image;
    }
    return null;
  }
  
  @override
  Widget build(BuildContext context) {
    final imageListCubit = BlocProvider.of<ImageListCubit>(context);

    return toolBarButton(
      Icons.arrow_back_ios,
      () async {
        final image = await _selectFile();
        if (image != null) {
          imageListCubit.addImage(ImageWrapper(image: image, width: imageWidth, height: imageHeight));
        }
      },
      Colors.grey.shade300,
      "Import"
    );
  }
}