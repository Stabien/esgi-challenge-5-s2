import 'package:image_picker/image_picker.dart';

Future<XFile?> pickImage() async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: ImageSource.gallery);

  return pickedFile;
}
