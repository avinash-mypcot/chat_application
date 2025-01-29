import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/textstyles.dart';

class ProfileTextfieldWidget extends StatelessWidget {
  const ProfileTextfieldWidget(
      {super.key,
      required TextEditingController nameController,
      this.isReadOnly = false,
      required this.formKey,
      required String textHint})
      : _nameController = nameController,
        _textHint = textHint;

  final TextEditingController _nameController;
  final String _textHint;
  final Key formKey;
  final bool isReadOnly;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // key: formKey,
      validator: (value) {
        if (value!.isEmpty) {
          return "Please enter data";
        }
        return null;
      },
      readOnly: isReadOnly,
      controller: _nameController,
      cursorColor: AppColors.kColorWhite,
      cursorHeight: 16.h,
      style: kTextStylePoppins300.copyWith(color: AppColors.kColorGrey),
      decoration: InputDecoration(
          focusColor: AppColors.kColorWhite,
          hintText: _textHint,
          hintStyle: kTextStylePoppins300.copyWith(color: AppColors.kColorGrey),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.kColorWhite)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide(color: AppColors.kColorWhite))),
    );
  }
}
