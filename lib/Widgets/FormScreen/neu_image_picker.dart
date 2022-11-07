import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import 'neu_button.dart';

class NeuImagePicker extends StatefulWidget {
  const NeuImagePicker({
    Key? key,
    required bool darkModeEnabled,
    required this.changePhoto,
  })  : _darkModeEnabled = darkModeEnabled,
        super(key: key);

  final bool _darkModeEnabled;
  final dynamic changePhoto;

  @override
  State<NeuImagePicker> createState() => _NeuImagePickerState();
}

class _NeuImagePickerState extends State<NeuImagePicker> {
  Future _captureImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      final imageTemp = File(image.path);
      widget.changePhoto(imageTemp);
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed! Error ${e.details.toString()}'),
      ));
    }
  }

  Future _pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemp = File(image.path);
      widget.changePhoto(imageTemp);
    } on PlatformException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed! Error ${e.details.toString()}'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            NeuButton(
              buttonLabel: "Camera",
              darkModeEnabled: widget._darkModeEnabled,
              performFunction: _captureImage,
            ),
            NeuButton(
              buttonLabel: "Gallery",
              darkModeEnabled: widget._darkModeEnabled,
              performFunction: _pickImage,
            ),
          ],
        ),
      ),
    );
  }
}
