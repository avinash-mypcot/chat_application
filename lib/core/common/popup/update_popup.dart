import 'dart:io';
import 'dart:ui';

import 'package:chat_application/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:svg_flutter/svg_flutter.dart';

import '../../constants/app_icons.dart';
import '../../theme/textstyles.dart';

void openVersionBottomSheet(BuildContext context, String redirectionUrl) {
    // final screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      backgroundColor: AppColors.kColorWhite,
      isScrollControlled: true,
      isDismissible: false,

      // clipBehavior: Clip.antiAlias,
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: PopScope(
            canPop: false,
            // ignore: deprecated_member_use
            onPopInvoked: (didPop) {},
            child: GestureDetector(
              onTap: () {
                // do nothing to prevent the background from being tapped
              },
              onVerticalDragDown: (_) {
                // do nothing to prevent the sheet from being dragged down
              },
              child: AnimatedPadding(
                padding: MediaQuery.of(context).viewInsets,
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticInOut,
                child: Container(
                  height: 218.h,
                  padding: EdgeInsets.all(24.h),
                  decoration: BoxDecoration(
                    color: AppColors.kColorWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.r),
                      topRight: Radius.circular(24.r),
                    ),
                    border: Border(
                      top: BorderSide(
                        width: 1.5.h,
                        color: AppColors.kColorWhite,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppIcons.appUpdateIc,
                            height: 24.h,
                            width: 24.h,
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Text(
                            'Something went wrong',
                            style: kTextStylePoppins600.copyWith(
                                fontSize: 18.sp,
                                color: AppColors.kColorBlack),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Kindly reach out to Mypcot team for further assistance.',
                        textAlign: TextAlign.left,
                        style: kTextStylePoppins400.copyWith(
                          fontSize: 16.sp,
                          color: AppColors.kColorBlack,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
