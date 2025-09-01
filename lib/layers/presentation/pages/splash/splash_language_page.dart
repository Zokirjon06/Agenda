import 'package:agenda/layers/presentation/pages/splash/splash_page.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashLanguagePage extends StatefulWidget {
  const SplashLanguagePage({super.key});

  @override
  State<SplashLanguagePage> createState() => _SplashLanguagePageState();
}

class _SplashLanguagePageState extends State<SplashLanguagePage> {
  String? _selectedLanguage = 'eng';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
  }

  void _loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() async {
      _selectedLanguage = prefs.getString('selectedlanguage') ?? 'eng';
    });
  }

  void _saveLanguage(String language) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('selectedlanguage', language);
    var auth = Hive.box("language");
    auth.put("language", language);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.standartColor,
      body: SafeArea(
          child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Text(
              "Kun tartibi",
              style: TextStyle(color: Colors.white, fontSize: 40.sp),
            ),
            Gap(40.h),
            Text(
              'O\'zingizga qulay tilni tanlang',
              style: TextStyle(color: Colors.white, fontSize: 20.sp),
            ),
            Gap(20.h),
            Container(
              width: 200.w,
              height: 50.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  border: Border.all(color: Colors.white)),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'uzb';
                    _saveLanguage('uzb');
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const SplashPage()),
                        (route) => false);
                  });
                },
                child: Center(
                    child: Text(
                  'O\'zbek',
                  style: TextStyle(color: Colors.white, fontSize: 17.sp),
                )),
              ),
            ),
            Gap(10.h),
            Container(
              width: 200.w,
              height: 50.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  border: Border.all(color: Colors.white)),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'uz';
                    _saveLanguage('uz');
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const SplashPage()),
                        (route) => false);
                  });
                },
                child: Center(
                    child: Text(
                  'Uzbek',
                  style: TextStyle(color: Colors.white, fontSize: 17.sp),
                )),
              ),
            ),
            Gap(10.h),
            Container(
              width: 200.w,
              height: 50.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  border: Border.all(color: Colors.white)),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'eng';
                    _saveLanguage('eng');
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const SplashPage()),
                        (route) => false);
                  });
                },
                child: Center(
                    child: Text(
                  'English',
                  style: TextStyle(color: Colors.white, fontSize: 17.sp),
                )),
              ),
            ),
            Gap(10.h),
            Container(
              width: 200.w,
              height: 50.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5.r),
                  border: Border.all(color: Colors.white)),
              child: InkWell(
                onTap: () {
                  setState(() {
                    _selectedLanguage = 'rus';
                    _saveLanguage('rus');
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const SplashPage()),
                        (route) => false);
                  });
                },
                child: Center(
                    child: Text(
                  'Russkiy',
                  style: TextStyle(color: Colors.white, fontSize: 17.sp),
                )),
              ),
            ),
            const Spacer(),
            const Spacer()
          ],
        ),
      )),
    );
  }
}
