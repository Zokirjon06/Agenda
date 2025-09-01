import 'package:agenda/layers/presentation/pages/hive/home_screen_hive_page.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';


class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
    var language = Hive.box("language");

  @override
  void initState() {
    Future.delayed(const Duration(seconds: 2))
        .then((value) => Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreenHivePage(language: language.values.first,)
                  // AddPage(language: language.values.first,)
            ),
            (route) => false));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.standartColor,
      body: Center(child: Text(language.values.first == 'eng' ? "Agenda" : language.values.first == 'rus' ? 'Eksjdcnkdjfn' : 'Kun tartibi',style: TextStyle(fontSize: 40.sp,color: Colors.white),),),
    );
  }
}