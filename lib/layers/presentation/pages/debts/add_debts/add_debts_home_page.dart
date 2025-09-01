import 'package:agenda/layers/presentation/pages/debts/add_debts/user_debts/add_user_debts_page.dart';
import 'package:agenda/layers/presentation/pages/debts/contact/contact_page.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddDebtsHomePage extends StatefulWidget {
  final String language;
  final bool lightMode;
  final bool pop;
  const AddDebtsHomePage(
      {super.key,
      required this.language,
      required this.lightMode,
      required this.pop});

  @override
  State<AddDebtsHomePage> createState() => _AddDebtsHomePageState();
}

class _AddDebtsHomePageState extends State<AddDebtsHomePage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        // elevation: 3,
        // shadowColor: Colors.black,
        // scrolledUnderElevation:  3,
        // backgroundColor:
        //     widget.lightMode ? AppColors.primary : AppColors.standartColor,
        foregroundColor: Colors.white,
         backgroundColor: widget.lightMode ? AppColors.primary : Color(0xff005a80),
           elevation: 3,
           shadowColor: Colors.black,
            systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: AppColors.standartColor, // Status bar rangini o'zgartirish
                statusBarIconBrightness: Brightness.light, // Ikonalar rangini o'zgartirish
              ),

        title: Text(
          widget.language == 'eng'
              ? 'Adding debts'
              : widget.language == 'rus'
                  ? 'Добавление долгов'
                  : "Qarzlarni qo'shish",
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        titleSpacing: 0,
        leadingWidth: null,
        
        // actions: [
        //   IconButton(
        //       onPressed: () => Navigator.of(context).push(MaterialPageRoute(
        //           builder: (context) => ContactPage(
        //               language: widget.language, lightMode: widget.lightMode))),
        //       icon: Icon(
        //         Icons.person,
        //         size: 30.sp,
        //         color: Colors.white,
        //       ))
        // ],
      ),
      backgroundColor:
          widget.lightMode ? AppColors.primary : AppColors.standartColor,
      body: Column(
        children: [
          Expanded(
            child: AddUserDebtsPage(
              language: widget.language,
              lightMode: widget.lightMode,
              pop: widget.pop,
            ),
          ),
        ],
      ),
    );
  }
}
