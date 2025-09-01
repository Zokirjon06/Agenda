import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SoundRecorder {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  bool _isRecorderInitialized = false;

  Future<void> init() async {
    await _recorder.openRecorder();
    _isRecorderInitialized = true;
  }

  Future<void> startRecording() async {
    if (!_isRecorderInitialized) return;

    final directory = await getApplicationDocumentsDirectory();
    String path = '${directory.path}/audio.aac';
    await _recorder.startRecorder(toFile: path);
  }

  Future<String?> stopRecording() async {
    if (!_isRecorderInitialized) return null;

    String? path = await _recorder.stopRecorder();
    return path;
  }

  void dispose() {
    _recorder.closeRecorder();
  }
}
