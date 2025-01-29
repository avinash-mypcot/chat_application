import 'package:ai_chatbot/core/theme/textstyles.dart';
import 'package:ai_chatbot/feature/auth/signup/presentation/widgets/signup_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';

class TextFields extends StatelessWidget {
  const TextFields({
    super.key,
    required TextEditingController emailController,
    required TextEditingController passController,
  })  : _emailController = emailController,
        _passController = passController;

  final TextEditingController _emailController;
  final TextEditingController _passController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Email Address",
          style: kTextStylePoppins300.copyWith(color: AppColors.kColorGrey),
        ),
        SizedBox(height: 8.h),
        SignupTextfield(
          nameController: _emailController,
          textHint: 'Enter Email',
          validation: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your Email';
            }
            // if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
            //   return 'Please enter a valid Email';
            // }
            return null;
          },
        ),

        // OTP Field
        SizedBox(
          height: 30.h,
        ),
        Text(
          "Password",
          style: kTextStylePoppins300.copyWith(color: AppColors.kColorGrey),
        ),
        SizedBox(height: 8.h),
        SignupTextfield(
          isPasswordField: true,
          nameController: _passController,
          textHint: 'Enter Password',
          validation: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the password';
            }
            return null;
          },
        ),
      ],
    );
  }
}
