import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

Future<void> uploadSoundFile(String filePath) async {
  File file = File(filePath);
  final storageRef = FirebaseStorage.instance.ref().child('sounds/audio.aac');

  try {
    await storageRef.putFile(file);
    String downloadUrl = await storageRef.getDownloadURL();
    print('Yuklandi: $downloadUrl');
  } catch (e) {
    print('Xatolik yuz berdi: $e');
  }
}
