import 'package:image_picker/image_picker.dart';

class LigarCamera {
  final picker = ImagePicker();

  Future<PickedFile> getImage() async {
    return await picker.getImage(source: ImageSource.camera);
  }
}
