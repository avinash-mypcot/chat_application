import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/textstyles.dart';

class SignupTextfield extends StatefulWidget {
  const SignupTextfield({
    super.key,
    required this.nameController,
    required this.textHint,
    required this.validation,
    this.isPasswordField = false,
  });

  final TextEditingController nameController;
  final String textHint;
  final FormFieldValidator validation;
  final bool isPasswordField;

  @override
  State<SignupTextfield> createState() => _SignupTextfieldState();
}

class _SignupTextfieldState extends State<SignupTextfield> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: widget.validation,
      controller: widget.nameController,
      obscureText: widget.isPasswordField ? _isObscure : false,
      cursorColor: AppColors.kColorWhite,
      cursorHeight: 16.h,
      style: kTextStylePoppins300.copyWith(color: AppColors.kColorGrey),
      decoration: InputDecoration(
        focusColor: AppColors.kColorWhite,
        hintText: widget.textHint,
        hintStyle: kTextStylePoppins300.copyWith(color: AppColors.kColorGrey),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.kColorWhite),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.kColorWhite),
        ),
        suffixIcon: widget.isPasswordField
            ? IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility : Icons.visibility_off,
                  color: AppColors.kColorGrey,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
            : null,
      ),
    );
  }
}
