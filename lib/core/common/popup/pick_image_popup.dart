import 'dart:io';

import 'package:ai_chatbot/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/textstyles.dart';
import '../../utils/utils.dart';

Future<File?> showModelBottomSheet(
    {required BuildContext context, required Function(File) imageFile}) {
  return showModalBottomSheet<File?>(
      backgroundColor: AppColors.kColorWhite,
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 252.h,
          child: Column(
            children: [
              SizedBox(height: 32.h),
              Padding(
                padding: EdgeInsets.only(left: 26.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.upload,
                      size: 24.sp,
                      weight: 24.h,
                    ),
                    SizedBox(width: 8.h),
                    Text(
                      "Upload",
                      style: kTextStylePoppins600.copyWith(
                        fontSize: 18.sp,
                        color: AppColors.kColorBlack,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Expanded(
                // ignore: avoid_unnecessary_containers
                child: Container(
                  // color: Colors.amberAccent,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          // Todo: call imagePicker
                          File? pickedImage = await AppUtils.pickImage(true);
                          if (pickedImage != null && context.mounted) {
                            imageFile(File(pickedImage.path));
                            Navigator.of(context).pop();
                            // Navigator.of(context).pop(File(pickedImage.path));
                          }
                        },
                        child: Container(
                          color: AppColors.kColorTransparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.photo,
                                size: 24.h,
                                weight: 24.w,
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                "gallery",
                                style: kTextStylePoppins400.copyWith(
                                  fontSize: 14.sp,
                                  color: AppColors.kColorBlack,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      RotatedBox(
                        quarterTurns: 1,
                        child: Divider(
                          color: AppColors.kColorBlack.withValues(alpha: 0.5),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          // Todo: call imagePicker
                          File? pickedImage = await AppUtils.pickImage(false);
                          if (pickedImage != null && context.mounted) {
                            imageFile(File(pickedImage.path));
                            Navigator.of(context).pop();
                            // Navigator.of(context).pop(File(pickedImage.path));
                          }
                        },
                        child: Container(
                          color: AppColors.kColorTransparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera,
                                size: 24.h,
                                weight: 24.w,
                              ),
                              SizedBox(height: 12.h),
                              Text(
                                "camera",
                                style: kTextStylePoppins400.copyWith(
                                  fontSize: 14.sp,
                                  color: AppColors.kColorBlack,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 24.h),
            ],
          ),
        );
      });
}
