import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'dart:io';

import 'package:permission_handler/permission_handler.dart';

class VoiceRecorderScreen extends StatefulWidget {
  final bool lightMode;
  const VoiceRecorderScreen({super.key, required this.lightMode});

  @override
  _VoiceRecorderScreenState createState() => _VoiceRecorderScreenState();
}

class _VoiceRecorderScreenState extends State<VoiceRecorderScreen> {
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  bool _isRecording = false;
  String? _filePath;
  List<String> _audioUrls = [];
  int? _playingIndex; // Bu o'ynayotgan audio faylning indeksini saqlash uchun
  // DateTime _timer = DateTime.now();
  // final _nov

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    _player = FlutterSoundPlayer();
    _player!.openPlayer();
    _loadAudioUrlsFromFirebase(); // Firebase'dan audio URL'larini yuklash
  }

  Future<void> _initializeRecorder() async {
    _recorder = FlutterSoundRecorder();
    await _recorder!.openRecorder();
    // Mikrofon ruxsatini tekshirish
    await Permission.microphone.request();
  }

  Future<void> _startRecording() async {
    if (await Permission.microphone.isGranted) {
      _filePath =
          '/sdcard/Download/voice_recording_${DateTime.now().millisecondsSinceEpoch}.aac';
      await _recorder!.startRecorder(toFile: _filePath);
      setState(() {
        _isRecording = true;
      });
    }
  }

  // Faqat bitta audio ijro etish
  Future<void> _playAudio(int index) async {
    // Agar oldin o'ynalayotgan audio bo'lsa, to'xtatamiz
    if (_playingIndex != null && _playingIndex != index) {
      await _player!.stopPlayer();
    }

    if (_player!.isPlaying) {
      // Agar hozirgi audio o'ynalayotgan bo'lsa, to'xtatamiz
      await _player!.stopPlayer();
      setState(() {
        _playingIndex = null; // Ijro to'xtadi
      });
    } else {
      try {
        await _player!.startPlayer(
          fromURI: _audioUrls[index],
          codec: Codec.aacADTS,
          whenFinished: () {
            setState(() {
              _playingIndex = null; // Ovoz tugaganda indeksni tozalash
            });
          },
        );
        setState(() {
          _playingIndex = index; // Hozirgi audio faylni o'ynayapti
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ovozni ijro etishda xatolik yuz berdi!'),
          ),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    await _recorder!.stopRecorder();
    setState(() {
      _isRecording = false;
    });
    _uploadToFirebase(); // Ovoz faylini Firebase'ga yuklash
  }

  Future<void> _uploadToFirebase() async {
    if (_filePath == null) return;
    final File file = File(_filePath!);
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('voice/${DateTime.now().millisecondsSinceEpoch}.aac');
    final uploadTask = storageRef.putFile(file);
    await uploadTask;
    final downloadUrl = await storageRef.getDownloadURL();
    setState(() {
      _audioUrls.add(downloadUrl); // Yangi URL'ni ro'yxatga qo'shish
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Ovoz muvaffaqiyatli yuklandi!')),
    );
  }

  // Firebase'dan audio URL'larini olish
  Future<void> _loadAudioUrlsFromFirebase() async {
    final storageRef = FirebaseStorage.instance.ref().child('voice');
    final listResult = await storageRef.listAll();
    List<String> audioUrls = [];
    for (var item in listResult.items) {
      final url = await item.getDownloadURL(); // URLni olish
      audioUrls.add(url);
    }
    setState(() {
      _audioUrls = audioUrls; // Olingan URL'larni ro'yxatga qo'shish
    });
  }
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Expanded(
          child: SingleChildScrollView(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _audioUrls.length,
              itemBuilder: (context, index) {
                return Card(
                   shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          elevation: 0,
          color: widget.lightMode == false
              ? const Color(0xFF112942)
              // : const Color.fromARGB(255, 6, 105, 120),
              : Colors.white10,
                   child: ListTile(
                      minVerticalPadding: 0,
                      // minTileHeight: 70.h,
                      leading: IconButton(
                          onPressed: () => _playAudio(index),
                          icon: Icon(
                            _playingIndex == index
                                ? Icons.pause_sharp
                                : Icons.play_arrow,
                            size: 45.sp,
                          )),
                      title: Text('Ovozli xabar ${index + 1}'),
                      subtitle: Text(
                          DateFormat.yMMMMEEEEd('uz_UZ').format(DateTime.now())),
              // trailing: index.m,
                    ),
                  
                );
              },
            ),
          ),
        
      ),
    );
  }

  @override
  void dispose() {
    _recorder!.closeRecorder();
    _player!.closePlayer();
    super.dispose();
  }
}
