//pick image from gallery
import 'dart:math';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/constant.dart';

String? pickedFilePath;
String pickedAvatar='';
Future<Uint8List?> pickImage() async {
  pickedFilePath = null;
  PickedFile? result = await ImagePicker.platform.pickImage(source: ImageSource.gallery,imageQuality: 25);
  // FilePickerResult? result = await FilePicker.platform
  //     .pickFiles(type: FileType.custom, allowedExtensions: ['jpg', 'png'],withData: true,);


  debugMessage('from pick image');
  if (result != null) {
    pickedFilePath = result.path;
    pickedAvatar='';
    return await result.readAsBytes();
  }
  return null;
}



updatePickedAvatar(String pickedAvatarr)
{
  pickedAvatar = pickedAvatarr;
  pickedFilePath =null;
}


//genrate a complex random number
String randomNumber() {
  String ans = '';
  int random = Random().nextInt(1000000);
  ans += random.toString();
  int random1 = Random().nextInt(1000000);
  ans += random1.toString();
  int random2 = Random().nextInt(1000000);
  ans += random2.toString();
  int random3 = Random().nextInt(1000000);
  ans += random3.toString();
  return ans;
}

//upload image to firebase storage
Future<String> uploadImage(Uint8List image) async {
  String imageUrl = '';
  try {
    String id = randomNumber();
    Reference reference = FirebaseStorage.instance.ref().child('images/$id');
    UploadTask uploadTask = reference.putData(image);
    await uploadTask.whenComplete(() async {
      imageUrl = await uploadTask.snapshot.ref.getDownloadURL();
    });
    debugMessage('from upload image');
  } catch (e) {
    debugMessage(e.toString());
  }

  return imageUrl;
}