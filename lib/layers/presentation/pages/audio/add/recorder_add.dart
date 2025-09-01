import 'dart:async';
import 'dart:io';

import 'package:agenda/layers/domain/models/hive_model/vois_recording_model/vois_recording_model.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_recorder.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class AddRecordingPage extends StatefulWidget {
  final String language;
  final bool lightMode;
  const AddRecordingPage(
      {super.key, required this.language, required this.lightMode});

  @override
  _AddRecordingPageState createState() => _AddRecordingPageState();
}

// (Yuqoridagi kodlar o'zgarmasdan qoladi)

class _AddRecordingPageState extends State<AddRecordingPage>
    with SingleTickerProviderStateMixin {
  FlutterSoundRecorder? _recorder;
  bool _isRecording = false;
  String? _filePath;
  Timer? _timer;
  int _elapsedSeconds = 0;
  late AnimationController _animationController;
  int _fileSize = 0; // Yozuv fayl hajmini saqlash uchun o'zgaruvchi

  @override
  void initState() {
    super.initState();
    _initializeRecorder();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1))
          ..repeat(reverse: true);
  }

  Future<void> _initializeRecorder() async {
    _recorder = FlutterSoundRecorder();
    await _recorder!.openRecorder();

    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mikrofon uchun ruxsat kerak!')),
      );
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
      _updateFileSize(); // Fayl hajmini yangilash
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _elapsedSeconds = 0;
    });
  }

  Future<void> _startRecording() async {
    if (await Permission.microphone.isGranted) {
      final directory = await getApplicationDocumentsDirectory();
      _filePath =
          '${directory.path}/voice_recording_${DateTime.now().millisecondsSinceEpoch}.aac';
      await _recorder!.startRecorder(toFile: _filePath);
      setState(() {
        _isRecording = true;
      });
      _startTimer();
    }
  }

  Future<void> _stopRecording() async {
    await _recorder!.stopRecorder();
    _stopTimer();
    setState(() {
      _isRecording = false;
    });
    await _saveToHive();
    Navigator.of(context).pop();
  }

  Future<void> _saveToHive() async {
    if (_filePath == null) return;
    try {
      final box = await Hive.openBox<VoiceRecordingModel>('voice_records');
      final voiceRecord = VoiceRecordingModel(
        filePath: _filePath!,
        description: 'Offline Record',
        date: DateTime.now(),
      );
      await box.add(voiceRecord);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ovoz muvaffaqiyatli saqlandi!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Xatolik: $e')),
      );
    }
  }

  // Fayl hajmini yangilash uchun metod
  Future<void> _updateFileSize() async {
    if (_filePath != null) {
      final file = File(_filePath!);
      if (await file.exists()) {
        final sizeInBytes = await file.length();
        setState(() {
          _fileSize = sizeInBytes;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String fileSizeText = _fileSize == 0
        ? 'Ovoz yozishni boshlash uchun tugmani bosing.'
        : _formatFileSize(_fileSize);

    return Scaffold(
      backgroundColor: widget.lightMode
          ? AppColors.homeBackgroundColor
          // : const Color(0xFF112132),
          : AppColors.standartColor,
      appBar: AppBar(
        title: Text(widget.language == 'eng'
            ? 'Recorder'
            : widget.language == 'rus'
                ? ''
                : 'Ovoz yozish'),
        // elevation: 3,
        // shadowColor: Colors.black,
        // backgroundColor: widget.lightMode
        //     ? AppColors.homeBackgroundColor
        //     : AppColors.standartColor
        foregroundColor: Colors.white,
        backgroundColor:
            widget.lightMode ? AppColors.primary : Color(0xff005a80),
        elevation: 3,
        shadowColor: Colors.black,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor:
              AppColors.standartColor, // Status bar rangini o'zgartirish
          statusBarIconBrightness:
              Brightness.light, // Ikonalar rangini o'zgartirish
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${(_elapsedSeconds ~/ 3600).toString().padLeft(2, '0')}:${(_elapsedSeconds % 3600 ~/ 60).toString().padLeft(2, '0')}:${(_elapsedSeconds % 60).toString().padLeft(2, '0')}',
            style: TextStyle(fontSize: 60.sp, color: Colors.lightBlueAccent),
          ),
          Gap(15.h),
          Center(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return ElevatedButton(
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: EdgeInsets.all(15.0),
                    // backgroundColor: _isRecording
                    //     ? Colors.redAccent.withOpacity(
                    //         0.5 + (_animationController.value * 0.5))
                    backgroundColor: Colors.blue
                      ..withOpacity(0.5 + (_animationController.value * 0.5)),
                    elevation: 10,
                  ).copyWith(
                    elevation: MaterialStateProperty.all(
                        10 + (_animationController.value * 5)),
                  ),
                  child: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    size: 45.sp,color: Colors.white,
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            fileSizeText,
            style: TextStyle(fontSize: 18.sp, color: Colors.lightBlueAccent),
          ),
        ],
      ),
    );
  }

  // Fayl hajmini formata keltirish metod
  String _formatFileSize(int bytes) {
    if (bytes < 1024) {
      return 'Yozib olingan: ${bytes}B'; // Baytlar
    } else if (bytes < 1024 * 1024) {
      return 'Yozib olingan: ${(bytes / 1024).toStringAsFixed(1)} KB'; // KB
    } else if (bytes < 1024 * 1024 * 1024) {
      return 'Yozib olingan: ${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB'; // MB
    } else {
      return 'Yozib olingan: ${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB'; // GB
    }
  }

  @override
  void dispose() {
    _recorder?.closeRecorder();
    _animationController.dispose();
    _timer?.cancel();
    super.dispose();
  }
}




// --------------------------------------------------------------------
// --------------------------------------------------------------------
// VoiceRecording Firebase 
// --------------------------------------------------------------------
// --------------------------------------------------------------------

// class AddRecordingPage extends StatefulWidget {
//   const AddRecordingPage({super.key});

//   @override
//   _VoiceRecordingPageState createState() => _VoiceRecordingPageState();
// }

// class _VoiceRecordingPageState extends State<AddRecordingPage> {
//   FlutterSoundRecorder? _recorder;
//   bool _isRecording = false;
//   String? _filePath;

//   @override
//   void initState() {
//     super.initState();
//     _initializeRecorder();
//   }

//   // Recorderni initializatsiya qilish
//   Future<void> _initializeRecorder() async {
//     _recorder = FlutterSoundRecorder();
//     await _recorder!.openRecorder();
//     await Permission.microphone.request();
//   }

//   // Ovoz yozishni boshlash
//   Future<void> _startRecording() async {
//     if (await Permission.microphone.isGranted) {
//       _filePath =
//           '/sdcard/Download/voice_recording_${DateTime.now().millisecondsSinceEpoch}.aac';
//       await _recorder!.startRecorder(toFile: _filePath);
//       setState(() {
//         _isRecording = true;
//       });
//     }
//   }

//   // Ovoz yozishni to'xtatish va Firebase-ga yuklash
//   Future<void> _stopRecording() async {
//     await _recorder!.stopRecorder();
//     setState(() {
//       _isRecording = false;
//     });
//     _uploadToFirebase();
//   }

//   // Firebase-ga yuklash
//   Future<void> _uploadToFirebase() async {
//     if (_filePath == null) return;
//     final File file = File(_filePath!);
//     final storageRef = FirebaseStorage.instance
//         .ref()
//         .child('voice/${DateTime.now().millisecondsSinceEpoch}.aac');
//     final uploadTask = storageRef.putFile(file);
//     await uploadTask;
//     final downloadUrl = await storageRef.getDownloadURL();
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Ovoz muvaffaqiyatli yuklandi!')),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: _isRecording ? _stopRecording : _startRecording,
//       style: ElevatedButton.styleFrom(
//           shape: CircleBorder(),
//           backgroundColor: _isRecording ? Colors.blue : Colors.white,
//           foregroundColor: _isRecording ? Colors.white : Colors.blue),
//       child: const Icon(Icons.mic),
//     );
//   }

//   @override
//   void dispose() {
//     _recorder!.closeRecorder();
//     super.dispose();
//   }
// }

