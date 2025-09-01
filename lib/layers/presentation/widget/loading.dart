import 'package:agenda/layers/presentation/pages/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';

class LoadingWidget extends StatelessWidget {
  final double? size;
  final Color? color;

  const LoadingWidget({super.key, this.size, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color ?? AppColors.primary,
      ),
    );
    // return Center(
    //   child: LoadingAnimationWidget.discreteCircle(
    //     color: color ?? AppColors.primary,
    //     size: size ?? 30.r,
    //   ),
    // );
  }
}


class ShimmerExampleDebt extends StatelessWidget {
  final bool lightMode;
  const ShimmerExampleDebt({super.key, required this.lightMode});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10, // Shimmer uchun 5ta element ko'rsatamiz.
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Shimmer.fromColors(
            baseColor: lightMode ? Colors.grey.shade600 : Colors.grey.shade800,
            highlightColor: Colors.grey.shade500,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Leading
                    Container(
                      width: 55.w,
                      height: 55.h,
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    Gap(15.w),
                    // Title va Subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Gap(13.h),
                          Container(
                            height: 10.h,
                            width: MediaQuery.of(context).size.width * 0.3,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          Gap(8.h),
                          Container(
                            height: 10.h,
                            width: MediaQuery.of(context).size.width * 0.6,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Gap(15.h)
              ],
            ),
          ),
        );
      },
    );
  }
}
