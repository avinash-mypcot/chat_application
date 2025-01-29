import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../../../../../core/router/app_router.gr.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/textstyles.dart';

class AlreadyAccount extends StatelessWidget {
  const AlreadyAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: kTextStylePoppins300.copyWith(
            color: AppColors.kColorWhite.withValues(alpha: 0.9),
          ),
        ),
        GestureDetector(
          onTap: () {
            context.router.replace(SignInRoute());
          },
          child: Text(
            "Login",
            style: kTextStylePoppins300.copyWith(
              decoration: TextDecoration.underline,
              decorationColor: AppColors.kColorWhite.withValues(alpha: 0.9),
              decorationStyle: TextDecorationStyle.solid,
              color: AppColors.kColorWhite.withValues(alpha: 0.9),
            ),
          ),
        ),
      ],
    );
  }
}
