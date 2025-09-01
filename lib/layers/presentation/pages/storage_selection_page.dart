import 'package:agenda/layers/presentation/pages/hive/home_screen_hive_page.dart';
import 'package:agenda/layers/presentation/pages/main/home_screen_page.dart';
import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class StorageSelectionPage extends StatelessWidget {
  const StorageSelectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.standartColor,
      appBar: AppBar(
        title: Text(
          'Choose Storage Type',
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.appBar,
        foregroundColor: Colors.white,
        elevation: 3,
        shadowColor: Colors.black,
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Logo or Icon
            Icon(
              Icons.storage,
              size: 80.sp,
              color: Colors.white,
            ),
            Gap(20.h),
            
            Text(
              'Select Your Preferred Storage',
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            
            Gap(10.h),
            
            Text(
              'Choose between cloud storage or local storage for your data',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
            ),
            
            Gap(50.h),
            
            // Firebase Option
            _buildStorageOption(
              context: context,
              icon: Icons.cloud,
              title: 'Firebase (Cloud)',
              subtitle: 'Store data in the cloud\nSync across devices\nRequires internet connection',
              color: Colors.orange,
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const HomeScreenPage(),
                  ),
                );
              },
            ),
            
            Gap(30.h),
            
            // Hive Option
            _buildStorageOption(
              context: context,
              icon: Icons.storage,
              title: 'Hive (Local)',
              subtitle: 'Store data locally on device\nWorks offline\nFaster access',
              color: Colors.green,
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const HomeScreenHivePage(language: 'uzb',),
                  ),
                );
              },
            ),
            
            Gap(50.h),
            
            // Info text
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: Colors.white24),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.blue,
                    size: 24.sp,
                  ),
                  Gap(12.w),
                  Expanded(
                    child: Text(
                      'You can switch between storage types anytime from the settings',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white70,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStorageOption({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: color.withOpacity(0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                icon,
                size: 40.sp,
                color: color,
              ),
            ),
            Gap(20.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Gap(8.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white70,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: color,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }
}
