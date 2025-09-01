import 'package:agenda/layers/presentation/pages/day/tasks/task_list_page.dart';
import 'package:agenda/layers/presentation/pages/debts/debts_list_page.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class NotesPage extends StatefulWidget {
  final String language;
  final bool lightMode;
  const NotesPage(
      {super.key, required this.lightMode, required this.language});

  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.lightMode
          ? AppColors.homeBackgroundColor
          : AppColors.standartColor,
      appBar: AppBar(
        backgroundColor: widget.lightMode
            ? AppColors.homeBackgroundColor
            : AppColors.standartColor,
            title: Text(
                      "Eslatmalar",
                      style: TextStyle(fontSize: 22.sp, color: Colors.white),
                    ),
        elevation: 3,
        shadowColor: Colors.black,
        actions: [
          IconButton(
              onPressed: () { 
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) => AddRecordingPage(
                //       language: widget.language, lightMode: widget.lightMode)));
                // _showBottomSheet(context);
                      },
              icon: Icon(Icons.add, size: 30.sp,color: Colors.white,))
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            
      //  VoisItem(language: widget.language, lightMode: widget.lightMode) ,
            
            
          ],
        ),
      ),
    );
  }
  //  void _showBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(30.r)),
  //     ),
  //     backgroundColor: AppColors.homeBackgroundColor ,
  //     builder: (BuildContext context) {
  //       return Padding(
  //         padding: EdgeInsets.symmetric(vertical: 16.h),
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Text("Eslatmalar qo'shing",style: TextStyle(fontSize: 18.sp,color: Colors.white),),
  //                          Divider(color:  Colors.white),

  //             Gap(20.h),
  //             Container(
  //               padding: EdgeInsets.symmetric(horizontal: 16.w),
  //               child: Column(children: [
  //               SizedBox(
  //               width: double.infinity,
  //               child: ElevatedButton(
  //                 onPressed: () {
  //                           Navigator.of(context).pop();
  //                   Navigator.of(context).push(MaterialPageRoute(
  //                       builder: (context) => TaskListPage(
  //                           language: widget. language,
  //                           lightMode: widget. lightMode,
  //                           )));

  //                 },
  //                 style: ElevatedButton.styleFrom(
  //                   padding: EdgeInsets.symmetric(vertical: 16.h),
  //                   backgroundColor: const Color(0xffF5F5F5),
  //                 ),
  //                 child: Text(
  //                   'Vazifalar ro\'yxati',
  //                   style: TextStyle(
  //                     color: const Color(0xff0C75AF),
  //                     fontSize: 20.sp,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Gap(15.h),
  //             SizedBox(
  //               width: double.infinity,
  //               child: ElevatedButton(
  //                 onPressed: () {
  //                           Navigator.of(context).pop();
  //                   Navigator.of(context).push(MaterialPageRoute(
  //                       builder: (context) => DebtsListPage(
  //                           language: widget.language,
  //                           lightMode: widget.lightMode,
  //                           )));
  //                 },
  //                 style: ElevatedButton.styleFrom(
  //                   padding: EdgeInsets.symmetric(vertical: 16.h),
  //                   backgroundColor: const Color(0xff0C75AF)
  //                 ),
  //                 child: Text(
  //                   'Qarzlar ro\'yxati',
  //                   style: TextStyle(
  //                     color: const Color(0xffF5F5F5),
  //                     fontSize: 20.sp,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Gap(15.h),
  //               SizedBox(
  //               width: double.infinity,
               

  //               child: ElevatedButton(
  //                 onPressed: () {
  //                           Navigator.of(context).pop();
  //                   Navigator.of(context).push(MaterialPageRoute(
  //                       builder: (context) => DebtsListPage(
  //                           language: widget.language,
  //                           lightMode: widget.lightMode,
  //                           )));
  //                 },
  //                 style: ElevatedButton.styleFrom(
  //                   padding: EdgeInsets.symmetric(vertical: 16.h),
  //                   // backgroundColor: const Color(0xff0C75AF),
  //                 ),
  //                 child: Text(
  //                   'Ovozli yozuvlar',
  //                   style: TextStyle(
  //                     color: const Color(0xffF5F5F5),
  //                     fontSize: 20.sp,
  //                     fontWeight: FontWeight.w600,
  //                   ),
  //                 ),
  //               ),
  //             ),
         
  //             ],),)
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }


}
