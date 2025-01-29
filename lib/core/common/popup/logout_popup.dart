import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../router/app_router.gr.dart';
import '../../theme/app_colors.dart';
import '../../theme/textstyles.dart';

class LogoutPopup extends StatefulWidget {
  const LogoutPopup({super.key});

  @override
  State<LogoutPopup> createState() => _LogoutPopupState();
}

class _LogoutPopupState extends State<LogoutPopup> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      child: Container(
        padding: EdgeInsets.all(12.sp),
        decoration: BoxDecoration(
            color: AppColors.kColorBlack.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(12.r)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: AppColors.kColored.withValues(alpha: 0.15),
                  // borderRadius:
                  //     BorderRadius.circular(12.r),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout_sharp,
                  color: AppColors.kColored.withValues(alpha: 0.7),
                )),
            SizedBox(
              height: 5.h,
            ),
            Text(
              "Logout ?",
              style: kTextStylePoppins600.copyWith(
                  fontSize: 16.sp,
                  color: AppColors.kColorWhite.withValues(alpha: 0.9)),
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              "Are you sure you want to logout ?",
              style: kTextStylePoppins400.copyWith(
                  fontSize: 12.sp,
                  color: AppColors.kColorWhite.withValues(alpha: 0.9)),
            ),
            SizedBox(
              height: 15.h,
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      context.router.maybePop();
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.sp),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                              color:
                                  AppColors.kColored.withValues(alpha: 0.7))),
                      child: Center(
                        child: Text(
                          "cancel",
                          style: kTextStylePoppins500.copyWith(
                              fontSize: 14.sp,
                              color:
                                  AppColors.kColorWhite.withValues(alpha: 0.9)),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      FirebaseAuth.instance.signOut();
                      context.router.replaceAll([SignInRoute()]);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10.sp),
                      decoration: BoxDecoration(
                        color: AppColors.kColored.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Center(
                        child: Text(
                          "logout",
                          style: kTextStylePoppins500.copyWith(
                              color:
                                  AppColors.kColorWhite.withValues(alpha: 0.9),
                              fontSize: 14.sp),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
