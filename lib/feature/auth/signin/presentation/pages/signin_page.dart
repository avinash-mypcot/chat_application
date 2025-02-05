
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/router/app_router.gr.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/textstyles.dart';
import '../bloc/signin_bloc.dart';
import '../bloc/signin_event.dart';
import '../bloc/signin_state.dart';
import '../widgets/signin_textfield.dart';

@RoutePage()
class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();

  bool isOtpSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            color: AppColors.kColorBlack.withOpacity(0.85),
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.0.sp, 16.0.sp, 16.0.sp,
                  MediaQuery.of(context).viewInsets.bottom),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Login",
                          style: kTextStylePoppins500.copyWith(
                            fontSize: 24.sp,
                            color: AppColors.kColorWhite.withValues(alpha: 0.9),
                          ),
                        ),
                        SizedBox(height: 30.h),
                        Text(
                          "Email Address",
                          style: kTextStylePoppins300.copyWith(
                              color: AppColors.kColorGrey),
                        ),
                        SizedBox(height: 8.h),
                        SigninTextfield(
                          nameController: _emailController,
                          textHint: 'Enter Email',
                          validation: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 30.h),
                        Text(
                          "Password",
                          style: kTextStylePoppins300.copyWith(
                              color: AppColors.kColorGrey),
                        ),
                        SizedBox(height: 8.h),
                        SigninTextfield(
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
                        SizedBox(height: 30.h),
                        GestureDetector(
                          onTap: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<SigninBloc>().add(SigninReqEvent(
                                  email: _emailController.text,
                                  password: _passController.text));

                              FocusScope.of(context).unfocus();
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(12.sp),
                            decoration: BoxDecoration(
                              color:
                                  AppColors.kColorWhite.withValues(alpha: 0.9),
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Center(
                              child: Text(
                                "Login",
                                style: kTextStylePoppins600.copyWith(
                                    color: AppColors.kColorBlack),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.center,
                        //   children: [
                        //     Text(
                        //       "Create an account? ",
                        //       style: kTextStylePoppins300.copyWith(
                        //         color: AppColors.kColorWhite
                        //             .withValues(alpha: 0.9),
                        //       ),
                        //     ),
                        //     GestureDetector(
                        //       onTap: () {
                        //         context.router.replace(SignUpRoute());
                        //       },
                        //       child: Text(
                        //         "Register",
                        //         style: kTextStylePoppins300.copyWith(
                        //           decoration: TextDecoration.underline,
                        //           decorationColor: AppColors.kColorWhite
                        //               .withValues(alpha: 0.9),
                        //           color: AppColors.kColorWhite
                        //               .withValues(alpha: 0.9),
                        //         ),
                        //       ),
                        //     ),
                        //   ],
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          BlocConsumer<SigninBloc, SigninState>(
            builder: (context, state) {
              if (state is SigninLoadingState) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              return SizedBox();
            },
            listener: (context, state) {
              if (state is SigninFailed) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.errorMessage)),
                );
              } else if (state is SigninSuccessState) {
                state.model.message != "User already signed in"?
                context.router.replace(ChatRoute()):ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.model.message)),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.model.message)),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
