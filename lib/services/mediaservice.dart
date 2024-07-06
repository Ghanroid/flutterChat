import 'dart:io';

import 'package:image_picker/image_picker.dart';

class Mediaservice {
  final ImagePicker _picker = ImagePicker();
  Mediaservice() {}

  Future<File?> getImagefromGallery() async {
    final XFile? _file = await _picker.pickImage(source: ImageSource.gallery);
    if (_file != null) {
      return File(_file!.path);
    }
    return null;
  }
}
