import 'dart:io';

import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  final _instance = ImagePicker();

  Future<File?> fromGallery() async {
    return await _instance.pickImage(source: ImageSource.gallery).then(
          (value) => (value == null) ? null : File(value.path),
        );
  }

  Future<File?> fromCamera() async {
    return await _instance.pickImage(source: ImageSource.camera).then(
          (value) => (value == null) ? null : File(value.path),
        );
  }
}
