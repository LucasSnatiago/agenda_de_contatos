import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class LigarCamera extends StatefulWidget {
  final void Function(File photo) sendImageData;
  final String previewImgUrl;

  LigarCamera(this.sendImageData, {this.previewImgUrl = ''});

  @override
  _LigarCameraState createState() => _LigarCameraState();
}

class _LigarCameraState extends State<LigarCamera> {
  final picker = ImagePicker();
  File file;

  Future<void> getImage() async {
    var img = await picker.getImage(source: ImageSource.camera);
    if (img == null) return;

    final tmpFile = await ImageCropper.cropImage(
        sourcePath: img.path,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        compressQuality: 75,
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Recorte sua imagem',
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true));

    if (tmpFile == null) return;

    setState(() {
      this.file = tmpFile;
    });

    widget.sendImageData(this.file);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: _buildCircleAvatarImage(),
        ),
        ElevatedButton(
            onPressed: () async => this.getImage(), child: Text('Tirar foto'))
      ],
    );
  }

  ImageProvider _buildCircleAvatarImage() {
    if (this.file != null)
      return FileImage(this.file);
    else if (widget.previewImgUrl != null)
      return NetworkImage(widget.previewImgUrl);
    return null;
  }
}
