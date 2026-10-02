import 'package:image_picker/image_picker.dart';
import 'package:payinall/core/utils/log_helper.dart';
import 'package:payinall/core/utils/log_level.dart';

abstract interface class ImagePickerService {
  Future<XFile?> selectFromGallery();
  Future<XFile?> takePhoto();
}

final class ImagePickerServiceImpl implements ImagePickerService {
  ImagePickerServiceImpl() {
    _imagePicker = ImagePicker();
  }

  late final ImagePicker _imagePicker;

  @override
  Future<XFile?> selectFromGallery() async {
    final image = await _imagePicker.pickImage(source: ImageSource.gallery);
    LogHelper.log(LogLevel.debug, 'Galeri resim seçildi: ${image?.path}');
    return image;
  }

  @override
  Future<XFile?> takePhoto() async {
    final image = await _imagePicker.pickImage(source: ImageSource.camera);
    LogHelper.log(LogLevel.debug, 'Kamera resim çekildi: ${image?.path}');
    return image;
  }
}
