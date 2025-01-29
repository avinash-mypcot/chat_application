import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/textstyles.dart';
import '../bloc/signup_bloc.dart';
import '../bloc/signup_event.dart';

class RegisterButton extends StatelessWidget {
  const RegisterButton({
    super.key,
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passController,
  })  : _formKey = formKey,
        _emailController = emailController,
        _passController = passController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailController;
  final TextEditingController _passController;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          context.read<SignUpBloc>().add(SignupReqEvent(
              email: _emailController.text, password: _passController.text));
        }
        FocusScope.of(context).unfocus();
      },
      child: Container(
        padding: EdgeInsets.all(12.sp),
        decoration: BoxDecoration(
            color: AppColors.kColorWhite.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(12.r)),
        child: Center(
          child: Text(
            "Register",
            style: kTextStylePoppins600.copyWith(color: AppColors.kColorBlack),
          ),
        ),
      ),
    );
  }
}
