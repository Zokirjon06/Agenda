import 'package:agenda/layers/presentation/pages/splash/splash_language_page.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';

class SettingsPage extends StatefulWidget {
  final String language;
  final bool lightMode;
  const SettingsPage(
      {super.key, required this.language, required this.lightMode});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var auth = Hive.box("language");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.standartColor,
      appBar: AppBar(
        title: Text(
          widget.language == 'eng'
              ? "Settings"
              : widget.language == 'rus'
                  ? "Долги"
                  : "Sozlamar",
          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.appBar,
        foregroundColor: Colors.white,
        elevation: 3,
        shadowColor: Colors.black,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor:
              AppColors.standartColor, // Status bar rangini o'zgartirish
          statusBarIconBrightness:
              Brightness.light, // Ikonalar rangini o'zgartirish
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(20.h),
                Text(
                  "Umumiy",
                  style: TextStyle(color: Colors.amber, fontSize: 19.sp),
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const SplashLanguagePage()),
                        (route) => false);
                  },
                  leading: Icon(
                    Icons.language,
                    color: Colors.white,
                    size: 25.sp,
                  ),
                  title: Text(
                    "Til",
                    style: TextStyle(color: Colors.white, fontSize: 19.sp),
                  ),
                  trailing: Text(
                    widget.language.toUpperCase(),
                    style: TextStyle(color: Colors.blue[300], fontSize: 19.sp),
                  ),
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                  onTap: () {},
                  leading: Icon(
                    Icons.currency_exchange,
                    color: Colors.white,
                    size: 25.sp,
                  ),
                  title: Text(
                    "Valyuta",
                    style: TextStyle(color: Colors.white, fontSize: 19.sp),
                  ),
                  trailing: Text(
                    "UZS",
                    style: TextStyle(color: Colors.blue[300], fontSize: 19.sp),
                  ),
                ),
                Gap(20.h),
                Text(
                  "Ilova haqida",
                  style: TextStyle(color: Colors.amber, fontSize: 19.sp),
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                  onTap: () {},
                  leading: Icon(
                    Icons.share,
                    color: Colors.white,
                    size: 25.sp,
                  ),
                  title: Text(
                    "Do'stlar bilan ulashish",
                    style: TextStyle(color: Colors.white, fontSize: 19.sp),
                  ),
                 
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                  onTap: () {},
                  leading: Icon(
                    Icons.grid_view_rounded,
                    color: Colors.white,
                    size: 25.sp,
                  ),
                  title: Text(
                    "Ko'proq ilovalar",
                    style: TextStyle(color: Colors.white, fontSize: 19.sp),
                  ),
                 
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                  onTap: () {},
                  leading: Icon(
                    Icons.message,
                    color: Colors.white,
                    size: 25.sp,
                  ),
                  title: Text(
                    "Fikr-mulohaza",
                    style: TextStyle(color: Colors.white, fontSize: 19.sp),
                  ),
                
                ),
                 Gap(20.h),
                Text(
                  "Ortimizdan yuring",
                  style: TextStyle(color: Colors.amber, fontSize: 19.sp),
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                  onTap: () {},
                  leading: Icon(
                    Icons.facebook,
                    color: Colors.white,
                    size: 25.sp,
                  ),
                  title: Text(
                    "Facebook",
                    style: TextStyle(color: Colors.white, fontSize: 19.sp),
                  ),
                 
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                  onTap: () {},
                  leading: Icon(
                    FontAwesomeIcons.instagram,
                    color: Colors.white,
                    size: 25.sp,
                  ),
                  title: Text(
                    "Instagram",
                    style: TextStyle(color: Colors.white, fontSize: 19.sp),
                  ),
                 
                ),
                ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                  onTap: () {},
                  leading: Icon(
                    FontAwesomeIcons.youtube,
                    color: Colors.white,
                    size: 25.sp,
                  ),
                  title: Text(
                    "Youtube",
                    style: TextStyle(color: Colors.white, fontSize: 19.sp),
                  ),
                
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}



            // Row(
            //   children: [
            //     Gap(16.h),
                // DropdownButtonHideUnderline(
                //   child: DropdownButton(
                //     value: _selectedLanguage,
                //     dropdownColor: Colors.deepPurple,
                //     icon: const Icon(Icons.language),
                //     items: const [
                //       DropdownMenuItem(
                //         value: "eng",
                //         child: Text(
                //           "en",
                //           style: TextStyle(color: Colors.white),
                //         ),
                //       ),
                //       DropdownMenuItem(
                //         value: "rus",
                //         child: Text(
                //           "ru",
                //           style: TextStyle(color: Colors.white),
                //         ),
                //       ),
                //       DropdownMenuItem(
                //         value: "uzb",
                //         child: Text(
                //           "uz",
                //           style: TextStyle(color: Colors.white),
                //         ),
                //       ),
                //     ],
                //     onChanged: (v) {
                //       setState(() {
                //         _selectedLanguage = v!;
                //         _saveLanguage(v); // Save selected language
                //       });
                //     },
                //   ),
                // ),
            //   ],
            // ),