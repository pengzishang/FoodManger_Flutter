import 'package:image_picker/image_picker.dart';
import 'dart:io';

class PhotoManger {
  factory PhotoManger() => _sharedInstance();

  // 静态私有成员，没有初始化
  static PhotoManger _instance;

  // 私有构造函数
  PhotoManger._() {
    // 具体初始化代码
  }

  // 静态、同步、私有访问点
  static PhotoManger _sharedInstance() {
    if (_instance == null) {
      _instance = PhotoManger._();
    }
    return _instance;
  }

  File currentImage;
  Future<File> getImage() async {
    currentImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    return currentImage;
  }

  Future<File> takeImage() async {
    currentImage = await ImagePicker.pickImage(source: ImageSource.camera);
    return currentImage;
  }
}
