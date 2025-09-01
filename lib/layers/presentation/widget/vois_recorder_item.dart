import 'package:agenda/layers/presentation/pages/add/add_page.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:agenda/layers/domain/models/hive_model/vois_recording_model/vois_recording_model.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';

class VoisItem extends StatefulWidget {
  final String language;
  final bool lightMode;
  const VoisItem({super.key, required this.language, required this.lightMode});

  @override
  State<VoisItem> createState() => _VoisItemState();
}

class _VoisItemState extends State<VoisItem> {
  late AudioPlayer _audioPlayer;
  int? _playingIndex;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  Future<void> _playRecording(String path, int index) async {
    await _audioPlayer.play(DeviceFileSource(path));
    setState(() {
      _playingIndex = index;
    });
  }

  Future<void> _pauseRecording() async {
    await _audioPlayer.pause();
    setState(() {
      _playingIndex = null;
    });
  }

  Future<void> _deleteRecording(Box<VoiceRecordingModel> box, int index) async {
    await box.deleteAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: FutureBuilder(
        future: Hive.openBox<VoiceRecordingModel>('voice_records'),
        builder: (context, AsyncSnapshot<Box<VoiceRecordingModel>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final box = snapshot.data!;
          return ValueListenableBuilder(
            valueListenable: box.listenable(),
            builder: (context, Box<VoiceRecordingModel> box, _) {
              final recordings = box.values.toList();
              bool hasRecordings = recordings.isNotEmpty;

              return Column(
                children: [
                  if (hasRecordings)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(16.r)),
                        color: Colors.white12,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(5.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.skip_next,
                                    color: Colors.white,
                                    size: 45.sp,
                                  )),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                    size: 45.sp,
                                  )),
                              IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.skip_next,
                                    color: Colors.white,
                                    size: 45.sp,
                                  )),
                              Gap(30.w),
                              Icon(
                                Icons.volume_mute,
                                color: Colors.white,
                              ),
                              Expanded(
                                child: Slider(
                                  value: 0.0,
                                  onChanged: (val) {},
                                  activeColor: Colors.white,
                                  inactiveColor: Colors.grey,
                                ),
                              ),
                              Icon(
                                Icons.volume_up,
                                color: Colors.white,
                              )
                            ],
                          ),
                          Slider(
                            value: 0.0,
                            onChanged: (val) {},
                            activeColor: Colors.white,
                            inactiveColor: Colors.grey,
                          )
                        ],
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: recordings.length,
                      itemBuilder: (context, index) {
                        final record = recordings[index];
                        return Column(
                          children: [
                            Gap(12.h),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 11.w,
                              ),
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white24),
                                  borderRadius: BorderRadius.circular(16.r),
                                  color: Colors.white12,
                                ),
                                child: ListTile(
                                  onTap: () {
                                    if (_playingIndex == index) {
                                      _pauseRecording();
                                    } else {
                                      _playRecording(record.filePath, index);
                                    }
                                  },
                                  minVerticalPadding: 0,
                                  minTileHeight: 70,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 5.w,
                                  ),
                                  leading: IconButton(
                                    icon: _playingIndex == index
                                        ? Icon(Icons.pause, size: 45.sp)
                                        : Icon(Icons.play_arrow, size: 45.sp),
                                    onPressed: () {
                                      if (_playingIndex == index) {
                                        _pauseRecording();
                                      } else {
                                        _playRecording(record.filePath, index);
                                      }
                                    },
                                    color: Colors.white,
                                  ),
                                  title: Text(
                                    'Yozuv: ${index + 1}',
                                    style: TextStyle(
                                        fontSize: 20.sp,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                  subtitle: Text(
                                    widget.language == 'eng'
                                        ? DateFormat.yMMMEd('en_US')
                                            .format(record.date)
                                        : widget.language == 'rus'
                                            ? DateFormat.yMMMEd('ru_RU')
                                                .format(record.date)
                                            : DateFormat.yMMMEd('uz_UZ')
                                                .format(record.date),
                                    style: TextStyle(
                                      fontSize: 15.sp,
                                      color: Colors.lightBlueAccent,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  trailing: Column(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.delete,
                                            size: 30.sp, color: Colors.red),
                                        onPressed: () {
                                          _deleteRecording(box, index);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

class VoisListItem extends StatefulWidget {
  final String language;
  final bool lightMode;
  const VoisListItem(
      {super.key, required this.language, required this.lightMode});

  @override
  State<VoisListItem> createState() => _VoisListItemState();
}

class _VoisListItemState extends State<VoisListItem> {
  late AudioPlayer _audioPlayer;
  int? _playingIndex;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  Future<void> _playRecording(String path, int index) async {
    await _audioPlayer.play(DeviceFileSource(path));
    setState(() {
      _playingIndex = index;
    });
  }

  Future<void> _pauseRecording() async {
    await _audioPlayer.pause();
    setState(() {
      _playingIndex = null;
    });
  }

  Future<void> _deleteRecording(Box<VoiceRecordingModel> box, int index) async {
    await box.deleteAt(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.standartColor,
      appBar: AppBar(
        backgroundColor: AppColors.appBar,
        foregroundColor: Colors.white,
        title: Text("Ovoz yozuvlari",style: TextStyle(fontSize: 22.sp,),),
        elevation: 3,
        shadowColor: Colors.black,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor:
              AppColors.standartColor, // Status bar rangini o'zgartirish
          statusBarIconBrightness:
              Brightness.light, // Ikonalar rangini o'zgartirish
        ),
        actions: [IconButton(onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => AddPage(language: widget.language, dropMenu: 'voice',)), (route) => false);
        }, icon: Icon(Icons.add,size: 30.sp,))],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: FutureBuilder(
          future: Hive.openBox<VoiceRecordingModel>('voice_records'),
          builder: (context, AsyncSnapshot<Box<VoiceRecordingModel>> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final box = snapshot.data!;
            return ValueListenableBuilder(
              valueListenable: box.listenable(),
              builder: (context, Box<VoiceRecordingModel> box, _) {
                final recordings = box.values.toList();
                bool hasRecordings = recordings.isNotEmpty;

                return Column(
                  children: [
                    if (hasRecordings)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(16.r)),
                          color: Colors.white12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(5.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.skip_next,
                                      color: Colors.white,
                                      size: 45.sp,
                                    )),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                      size: 45.sp,
                                    )),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.skip_next,
                                      color: Colors.white,
                                      size: 45.sp,
                                    )),
                                Gap(30.w),
                                Icon(
                                  Icons.volume_mute,
                                  color: Colors.white,
                                ),
                                Expanded(
                                  child: Slider(
                                    value: 0.0,
                                    onChanged: (val) {},
                                    activeColor: Colors.white,
                                    inactiveColor: Colors.grey,
                                  ),
                                ),
                                Icon(
                                  Icons.volume_up,
                                  color: Colors.white,
                                )
                              ],
                            ),
                            Slider(
                              value: 0.0,
                              onChanged: (val) {},
                              activeColor: Colors.white,
                              inactiveColor: Colors.grey,
                            )
                          ],
                        ),
                      ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: recordings.length,
                        itemBuilder: (context, index) {
                          final record = recordings[index];
                          return Column(
                            children: [
                              Gap(12.h),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 11.w,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white24),
                                    borderRadius: BorderRadius.circular(16.r),
                                    color: Colors.white12,
                                  ),
                                  child: ListTile(
                                    onTap: () {
                                      if (_playingIndex == index) {
                                        _pauseRecording();
                                      } else {
                                        _playRecording(record.filePath, index);
                                      }
                                    },
                                    minVerticalPadding: 0,
                                    minTileHeight: 70,
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 5.w,
                                    ),
                                    leading: IconButton(
                                      icon: _playingIndex == index
                                          ? Icon(Icons.pause, size: 45.sp)
                                          : Icon(Icons.play_arrow, size: 45.sp),
                                      onPressed: () {
                                        if (_playingIndex == index) {
                                          _pauseRecording();
                                        } else {
                                          _playRecording(
                                              record.filePath, index);
                                        }
                                      },
                                      color: Colors.white,
                                    ),
                                    title: Text(
                                      'Yozuv: ${index + 1}',
                                      style: TextStyle(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    subtitle: Text(
                                      widget.language == 'eng'
                                          ? DateFormat.yMMMEd('en_US')
                                              .format(record.date)
                                          : widget.language == 'rus'
                                              ? DateFormat.yMMMEd('ru_RU')
                                                  .format(record.date)
                                              : DateFormat.yMMMEd('uz_UZ')
                                                  .format(record.date),
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: Colors.lightBlueAccent,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    trailing: Column(
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.delete,
                                              size: 30.sp, color: Colors.red),
                                          onPressed: () {
                                            _deleteRecording(box, index);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}
